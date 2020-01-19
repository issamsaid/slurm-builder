#!/usr/bin/env bash
set -ex

SLURM_VERSION=19.05.0
UBUNTU_CODENAME='bionic'

#UBUNTU_CODENAMES='xenial bionic'
CENTOS_RELEASES='7'

NAME=slurm-build
DIST_DIR=./dist

docker build --pull -t "$NAME" \
             --file=./Dockerfile.ubuntu \
             --build-arg SLURM_VERSION="$SLURM_VERSION" \
             --build-arg UBUNTU_CODENAME="$UBUNTU_CODENAME" \
            .
docker ps -q -a -f "name=$NAME" | xargs -r docker rm 
docker create --name="$NAME" "$NAME"
rm -rf "$DIST_DIR"
docker cp "${NAME}:/dist" "$DIST_DIR"
docker rm "$NAME"
