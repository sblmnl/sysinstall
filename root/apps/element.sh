#!/bin/sh

program_name="element"

# import keyring
keyring_url="https://packages.element.io/debian/element-io-archive-keyring.gpg"
keyring_file="/etc/apt/keyrings/element-io.asc"
keyring_fpr="12D4CD600C2240A9F4A82071D7B0B66941D01538"

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

chattr +i $keyring_file

# add apt repository
apt_srcs_file="/etc/apt/sources.list.d/element-io.sources"

tee $apt_srcs_file <<EOF
Types: deb
URIs: https://packages.element.io/debian/
Suites: default
Components: main
Signed-By: ${keyring_file}
EOF

chattr +i $apt_srcs_file

# install element
apt update && apt install element-desktop
