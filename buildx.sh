#!/usr/bin/env sh
#shellcheck shell=sh

REPO=mikenye
IMAGE=opensky-network
PLATFORMS="linux/amd64,linux/arm/v7,linux/arm64"

docker context use x86_64
export DOCKER_CLI_EXPERIMENTAL="enabled"
docker buildx use homecluster

# Build & push latest
docker buildx build -t "${REPO}/${IMAGE}:latest" --compress --push --platform "${PLATFORMS}" .

# Get readsb version from latest
docker pull "${REPO}/${IMAGE}:latest"
VERSION=$(docker run --entrypoint cat "${REPO}/${IMAGE}:latest" /VERSIONS | grep opensky-feeder | cut -d " " -f 2)

# Build & push version-specific
docker buildx build -t "${REPO}/${IMAGE}:${VERSION}" --compress --push --platform "${PLATFORMS}" .
