#!/bin/sh

program_name="dbeaver"

# import keyring
keyring_url="https://dbeaver.io/debs/dbeaver.gpg.key"
keyring_file="/etc/apt/keyrings/dbeaver.asc"
keyring_fpr="98F5A7CC1ABE72AC3852A007D33A1BD725ED047D"

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

# add apt repository
tee /etc/apt/sources.list.d/dbeaver.sources <<EOF 
Types: deb
URIs: https://dbeaver.io/debs/dbeaver-ce/
Suites: /
Components: 
Signed-By: ${keyring_file}
EOF

# install dbeaver
apt update && apt install -y dbeaver-ce
