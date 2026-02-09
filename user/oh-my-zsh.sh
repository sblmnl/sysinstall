#!/bin/sh

commit_hash="b52dd1a425e9ed9f844ba46cd27ff94a3b4949dc"
checksum="ce0b7c94aa04d8c7a8137e45fe5c4744e3947871f785fd58117c480c1bf49352"

curl -fsSLO https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/$commit_hash/tools/install.sh

if ! echo "$checksum  install.sh" | sha256sum -c --status -; then
    echo "[ERR] oh my zsh - checksum verification failed!" >&2 
    rm install.sh
    exit 1
fi

bash install.sh --unattended

rm install.sh

mv ~/.profile.bak ~/.profile
mv ~/.zprofile.bak ~/.zprofile
