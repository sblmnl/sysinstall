#!/bin/sh

program_name="dotnet"

# import keyring
keyring_url="https://packages.microsoft.com/keys/microsoft.asc"
keyring_file="/etc/apt/keyrings/microsoft.asc"
keyring_fpr="BC528686B50D79E339D3721CEB3E94ADBE1229CF"

if [ ! -f "$keyring_file" ]; then
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
fi

# add apt repository
os_version_codename="$( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release )"

tee /etc/apt/sources.list.d/microsoft-prod.sources <<EOF
Types: deb
URIs: https://packages.microsoft.com/debian/13/prod/
Suites: ${os_version_codename}
Components: main
Signed-By: ${keyring_file}
EOF

# install dotnet
apt update && apt install -y dotnet-sdk-10.0
