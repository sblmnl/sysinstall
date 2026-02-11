#!/bin/sh

program_name="nvm"

checksum="2d8359a64a3cb07c02389ad88ceecd43f2fa469c06104f92f98df5b6f315275f"

curl -fsSLO https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh

if ! echo "$checksum  install.sh" | sha256sum -c --status -; then
    echo "[ERR] $program_name - checksum verification failed!" >&2
    rm install.sh
    exit 1
fi

bash install.sh
\. "$HOME/.nvm/nvm.sh"
nvm install 24

rm install.sh
