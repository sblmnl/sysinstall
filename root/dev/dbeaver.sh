#!/bin/sh

program_name="dbeaver"

# import keyring
keyring_url="https://dbeaver.io/debs/dbeaver.gpg.key"
keyring_file="/etc/apt/keyrings/dbeaver.asc"
keyring_fpr="BDFB19F681514B43875D16FA132C13A8A330F403"

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

chattr +i $keyring_file

# add apt repository
apt_srcs_file="/etc/apt/sources.list.d/dbeaver.sources"

tee $apt_srcs_file <<EOF
Types: deb
URIs: https://dbeaver.io/debs/dbeaver-ce/
Suites: /
Components: 
Signed-By: ${keyring_file}
EOF

chattr +i $apt_srcs_file

# install dbeaver
apt update && apt install -y dbeaver-ce
