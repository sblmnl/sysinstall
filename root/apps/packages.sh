#!/bin/sh

# disk and backup utilities
apt install -y \
    gnome-disk-utility \
    timeshift

# gui apps
apt install -y \
    kitty \
    thunar \
    xarchiver \
    flameshot \
    qimgv \
    vlc \
    qbittorrent \
    libreoffice \
    gimp \
    gpick \
    keepassxc

# cli utilities
apt install -y \
    eza \
    htop \
    feh \
    cmus \
    calc \
    stow

# install flatpak
apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
