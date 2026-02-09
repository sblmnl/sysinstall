#!/bin/sh

program_name="google-chrome"

# import keyring
keyring_url="https://dl.google.com/linux/linux_signing_key.pub"
keyring_file="/etc/apt/keyrings/google-chrome.asc"
keyring_fpr="EB4C1BFD4F042F6DDDCCEC917721F63BD38B4796"

curl -fsSLo $keyring_file $keyring_url

if [ $(gpg --show-keys --with-colons $keyring_file \
    | awk -F: '$1=="pub",($1!="pub"&&$2=="-"){if($1=="fpr"){print$10}}' \
    | tr '\n' ' ' \
    | sed 's/ $//') != $keyring_fpr ]
then
    echo "[ERR] $program_name - keyring fingerprint verification failed!" >&2
    rm $keyring_file
    exit 1
fi

# add apt repository
tee /etc/apt/sources.list.d/google-chrome.sources <<EOF
Types: deb
URIs: https://dl.google.com/linux/chrome/deb/
Suites: stable
Components: main
Signed-By: ${keyring_file}
EOF

# install google chrome
apt update && apt install -y google-chrome-stable
