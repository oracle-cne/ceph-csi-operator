#!/usr/bin/env bash

set -x

CONTAINER_CLI="${CONTAINER_CLI:-podman}"

name="ceph-csi-operator"
version="{{{ .major }}}.{{{ .minor }}}.{{{ .patch }}}"
registry="container-registry.oracle.com/olcne"
docker_tag=${registry}/${name}:v${version}

args=(--build-arg https_proxy=${https_proxy}
        --build-arg version=${version})

[[ -f /etc/yum.repos.internal.d/ol_artifacts.repo ]] && \
        args+=(--volume /etc/yum.repos.internal.d/ol_artifacts.repo:/etc/yum.repos.internal.d/ol_artifacts.re
[[ -f /etc/yum.conf ]] && args+=(--volume /etc/yum.conf:/etc/yum.conf)

args+=(-t ${docker_tag} -f ./olm/builds/Dockerfile .)

"${CONTAINER_CLI}" build --pull "${args[@]}"
