#!/bin/sh

program_name="vscode"

# import keyring
keyring_url="https://packages.microsoft.com/keys/microsoft.asc"
keyring_file="/etc/apt/keyrings/microsoft.asc"
keyring_fpr="BC528686B50D79E339D3721CEB3E94ADBE1229CF"

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
apt_srcs_file="/etc/apt/sources.list.d/vscode.sources"
os_arch="$( dpkg --print-architecture )"

tee $apt_srcs_file <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: ${os_arch}
Signed-By: ${keyring_file}
EOF

chattr +i $apt_srcs_file

# install vscode
apt update && apt install -y code
