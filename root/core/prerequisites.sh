#!/bin/sh

tee /etc/apt/sources.list <<EOF
#deb cdrom:[Debian GNU/Linux 13.3.0 _Trixie_ - Official amd64 NETINST with firmware 20260110-10:59]/ trixie contrib main non-free-firmware

deb https://deb.debian.org/debian/ trixie main non-free-firmware contrib non-free
deb-src https://deb.debian.org/debian/ trixie main non-free-firmware contrib non-free

deb https://security.debian.org/debian-security trixie-security main non-free-firmware contrib non-free
deb-src https://security.debian.org/debian-security trixie-security main non-free-firmware contrib non-free

# trixie-updates, to get updates before a point release is made;
# see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
deb https://deb.debian.org/debian/ trixie-updates main non-free-firmware contrib non-free
deb-src https://deb.debian.org/debian/ trixie-updates main non-free-firmware contrib non-free

# This system was installed using removable media other than
# CD/DVD/BD (e.g. USB stick, SD card, ISO image file).
# The matching "deb cdrom" entries were disabled at the end
# of the installation process.
# For information about how to configure apt package sources,
# see the sources.list(5) manual.
EOF

apt modernize-sources
apt update
apt upgrade -y

# set apt keyring permissions
install -m 0755 -d /etc/apt/keyrings

# install prerequisite packages
apt install -y \
    sudo \
    build-essential \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    gnupg \
    pinentry-tty \
    git \
    curl \
    wget \
    7zip \
    unzip \
    calc \
    jq \
    bc \
    python3-full \
    python3-pip \
    pcscd

# add me to sudoers
usermod -aG sudo jared
