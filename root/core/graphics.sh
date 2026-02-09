#!/bin/sh

apt install -y \
    linux-headers-$(dpkg --print-architecture) \
    nvidia-kernel-dkms \
    nvidia-driver \
    firmware-misc-nonfree
