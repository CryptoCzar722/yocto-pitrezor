#!/bin/bash
set -e

IMAGE=pitrezor-build
TAG=${1:-master}
IMGFILE=images/pitrezor-$TAG.img
DOCKER_UID=30000

mkdir -p images
chown $DOCKER_UID:$DOCKER_UID images

docker build -t $IMAGE .

docker run -t --rm -v $(pwd)/images:/images:z $IMAGE /bin/bash -c "\
git clone https://github.com/3rdIteration/yocto-pitrezor.git && \
cd yocto-pitrezor && \
git checkout $TAG && \
git submodule update --init --recursive && \
. poky/oe-init-build-env build && \
bitbake pitrezor-image && \
cp tmp/deploy/images/raspberrypi/pitrezor-image-raspberrypi.rpi-sdimg /$IMGFILE"

zip -m -j -9 ${IMGFILE%.img}.zip $IMGFILE

