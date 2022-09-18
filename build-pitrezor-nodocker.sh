#!/bin/bash
set -e

IMAGE=pitrezor-build
TAG=${1:-master}
IMGFILE=images/pitrezor-$TAG.img

mkdir -p images
git checkout $TAG
git submodule update --init --recursive
. poky/oe-init-build-env build
bitbake pitrezor-image
cp tmp/deploy/images/raspberrypi0-wifi/pitrezor-image-raspberrypi0-wifi.rpi-sdimg /$IMGFILE

zip -m -j -9 ${IMGFILE%.img}.zip $IMGFILE