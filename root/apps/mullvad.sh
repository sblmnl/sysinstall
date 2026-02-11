#!/bin/sh

program_name="mullvad"

# import keyring
keyring_url="https://repository.mullvad.net/deb/mullvad-keyring.asc"
keyring_file="/etc/apt/keyrings/mullvad.asc"
keyring_fpr="A1198702FC3E0A09A9AE5B75D5A1D4F266DE8DDF"

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
apt_srcs_file="/etc/apt/sources.list.d/mullvad.sources"
os_version_codename="$( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release )"

tee $apt_srcs_file <<EOF
Types: deb
URIs: https://repository.mullvad.net/deb/stable/
Suites: ${os_version_codename}
Components: main
Signed-By: ${keyring_file}
EOF

chattr +i $apt_srcs_file

# install mullvad-browser and mullvad-vpn
apt update && apt install -y mullvad-browser mullvad-vpn
