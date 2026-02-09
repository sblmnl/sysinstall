#!/bin/sh

# add apt repositories
tee /etc/apt/sources.list.d/debian.sources <<EOF
Types: deb deb-src
URIs: http://deb.debian.org/debian/
Suites: trixie
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb deb-src
URIs: http://security.debian.org/debian-security/
Suites: trixie-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb deb-src
URIs: http://deb.debian.org/debian/
Suites: trixie-updates
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF

apt update && apt upgrade -y

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
    minisign \
    pinentry-tty \
    git \
    curl \
    wget \
    7zip \
    unzip \
    calc \
    jq \
    bc \
    python3-full

# add me to sudoers
usermod -aG sudo jared
