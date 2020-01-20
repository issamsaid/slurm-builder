#!/usr/bin/env bash
set -ex
# change below with the version of PMIx you would like to install: 
PMIX_VERSION=3.1.4
# change below with the version of Slurm you would like to install: 
SLURM_VERSION=19.05.0
# we want to install Slurm/PMIx on 18.04.3 LTS:
UBUNTU_CODENAME='bionic'
# add name to the container:
CONTAINER_NAME=slurm-pmix-build
# the directory where to install the deb files after the build:
DIST_DIR=./dist
# build the container:
docker build --pull -t "${CONTAINER_NAME}"                    \
             --file=./Dockerfile.ubuntu                       \
             --build-arg PMIX_VERSION="${PMIX_VERSION}"       \
             --build-arg SLURM_VERSION="${SLURM_VERSION}"     \
             --build-arg UBUNTU_CODENAME="${UBUNTU_CODENAME}" \
            .
# if we have a previous instance we kill it:
docker ps -q -a -f "name=${CONTAINER_NAME}" | xargs docker rm -f 
# create a new instance:
docker create --name="${CONTAINER_NAME}" "${CONTAINER_NAME}"
# remove the distination directory if not existing:
rm -rf "${DIST_DIR}"
# copy the internal deb files to the distination directory:
docker cp "${CONTAINER_NAME}:/dist" "${DIST_DIR}"
docker rm "${CONTAINER_NAME}"
