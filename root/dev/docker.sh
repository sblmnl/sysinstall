#!/bin/sh

program_name="docker"

# import keyring
keyring_url="https://download.docker.com/linux/debian/gpg"
keyring_file="/etc/apt/keyrings/docker.asc"
keyring_fpr="9DC858229FC7DD38854AE2D88D81803C0EBFCD88"

if [ ! -f "$keyring_file" ]; then
    curl -fsSLo $keyring_file $keyring_url
fi

if [ $(gpg --show-keys --with-colons $keyring_file \
    | awk -F: '$1=="pub",($1!="pub"&&$2=="-"){if($1=="fpr"){print$10}}' \
    | tr '\n' ' ' \
    | sed 's/ $//') != $keyring_fpr ]
then
    echo "[ERR] $program_name - keyring fingerprint verification failed!" >&2
    rm $keyring_file
    exit 1
fi

chmod a+r $keyring_file

# add apt repository
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: ${keyring_file}
EOF

apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

usermod -aG docker jared
