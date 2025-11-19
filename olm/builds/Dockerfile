FROM container-registry.oracle.com/os/oraclelinux:9 AS builder

COPY ol_artifacts.repo /etc/yum.repos.d/
RUN cat /etc/yum.repos.d/ol_artifacts.repo
RUN dnf repolist enabled 
RUN dnf repolist disabled 

RUN dnf config-manager --enable ol9_codeready_builder && \
    dnf update -y && dnf install --setopt=ol9_appstream.exclude=golang -y golang patch

WORKDIR /ceph-csi-operator
COPY . .
ARG version
RUN patch < olm/Makefile.patch && \
    make build GOFLAGS="-trimpath=false" LDFLAGS="-X main.version=v${version}"

FROM container-registry.oracle.com/os/oraclelinux:9-slim

# COPY LICENSE NOTICE THIRD_PARTY_LICENSES.txt olm/SECURITY.md /usr/share/licenses/
COPY --from=builder /ceph-csi-operator/LICENSE /ceph-csi-operator/olm/SECURITY.md /ceph-csi-operator/THIRD_PARTY_LICENSES.txt /usr/share/licenses/
COPY --from=builder /ceph-csi-operator/bin/manager /usr/local/bin/manager

RUN microdnf update -y && \
    microdnf clean all && \
    rm -rf /var/cache/yum/* && \
    test -d /LICENSES || ln -s /usr/share/licenses /LICENSES

USER 65532:65532

ENTRYPOINT ["/usr/local/bin/manager"]
