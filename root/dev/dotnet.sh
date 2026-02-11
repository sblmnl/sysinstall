#!/bin/sh

program_name="dotnet"

# import keyring
keyring_url="https://packages.microsoft.com/keys/microsoft-2025.asc"
keyring_file="/etc/apt/keyrings/microsoft-prod.asc"
keyring_fpr="AA86F75E427A19DD33346403EE4D7792F748182B"

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
apt_srcs_file="/etc/apt/sources.list.d/microsoft-prod.sources"
os_version_codename="$( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release )"

tee $apt_srcs_file <<EOF
Types: deb
URIs: https://packages.microsoft.com/debian/13/prod/
Suites: ${os_version_codename}
Components: main
Signed-By: ${keyring_file}
EOF

chattr +i $apt_srcs_file

# install dotnet
apt update && apt install -y dotnet-sdk-10.0
