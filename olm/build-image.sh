#!/usr/bin/env bash

set -x

CONTAINER_CLI="${CONTAINER_CLI:-podman}"

name="ceph-csi-operator"
version="0.4.0"
registry="container-registry.oracle.com/olcne"
docker_tag=${registry}/${name}:v${version}-1

dnf repolist --enabled -v
ls -lh "/etc/yum.repos.internal.d/"
grep "incubator" -r "/etc/yum.repos.internal.d/"
if [ -f "/etc/yum.repos.internal.d/ol_artifacts.repo" ]; then
    cp /etc/yum.repos.internal.d/ol_artifacts.repo ./
    cat ol_artifacts.repo
fi

"${CONTAINER_CLI}" build --pull \
    --build-arg https_proxy=${https_proxy} \
    --build-arg version=${version} \
    -t ${docker_tag} -f ./olm/builds/Dockerfile .
