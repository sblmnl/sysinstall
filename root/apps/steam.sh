#!/bin/sh

dpkg --add-architecture i386

apt update

apt install -y \
    steam-installer \
    mesa-vulkan-drivers \
    libglx-mesa0:i386 \
    mesa-vulkan-drivers:i386 \
    libgl1-mesa-dri:i386
