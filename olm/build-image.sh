#!/usr/bin/env bash

set -x

CONTAINER_CLI="${CONTAINER_CLI:-podman}"

name="ceph-csi-operator"
version="0.4.0"
registry="container-registry.oracle.com/olcne"
docker_tag=${registry}/${name}:v${version}

"${CONTAINER_CLI}" build --pull \
    --build-arg https_proxy=${https_proxy} \
    --build-arg version=${version} \
    -t ${docker_tag} -f ./olm/builds/Dockerfile .
