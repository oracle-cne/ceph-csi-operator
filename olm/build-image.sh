#!/usr/bin/env bash

set -x

CONTAINER_CLI="${CONTAINER_CLI:-podman}"

name="ceph-csi-operator"
version="0.4.0"
registry="container-registry.oracle.com/olcne"
docker_tag=${registry}/${name}:v${version}-1

args=(--build-arg https_proxy=${https_proxy}
	--build-arg version=${version})

[[ -f /etc/yum.repos.internal.d/ol_artifacts.repo ]] && \
	args+=(--volume /etc/yum.repos.internal.d/ol_artifacts.repo:/etc/yum.repos.internal.d/ol_artifacts.repo --build-arg DNF_GOLANG_ARG="--setopt=ol9_appstream.exclude=golang")
[[ -f /etc/yum.conf ]] && args+=(--volume /etc/yum.conf:/etc/yum.conf)

args+=(-t ${docker_tag} -f ./olm/builds/Dockerfile .)

"${CONTAINER_CLI}" build --pull "${args[@]}"
