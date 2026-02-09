#!/bin/sh

program_name="signal"

# import keyring
keyring_url="https://updates.signal.org/desktop/apt/keys.asc"
keyring_file="/etc/apt/keyrings/signal-desktop.asc"
keyring_fpr="DBA36B5181D0C816F630E889D980A17457F6FB06"

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
tee /etc/apt/sources.list.d/signal-xenial.sources <<EOF
Types: deb
URIs: https://updates.signal.org/desktop/apt/
Suites: xenial
Components: main
Signed-By: ${keyring_file}
EOF

# install signal
apt update && apt install -y signal-desktop
