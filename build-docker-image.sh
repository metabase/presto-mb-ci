#!/bin/bash

# builds this Docker image for linux/amd64 (the platform of the CI runners), tagged with the Presto version.
# add --push to push it to Docker Hub

PRESTO_VERSION=$(sed -n 's/^FROM prestodb\/presto:\(.*\)$/\1/p' Dockerfile)

docker buildx build --platform linux/amd64 . -t "metabase/presto-mb-ci:${PRESTO_VERSION}" --load "$@"
