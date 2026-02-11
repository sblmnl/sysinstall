#!/bin/sh

program_name="spotify"

# import keyring
keyring_url="https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg"
keyring_file="/etc/apt/keyrings/spotify.asc"
keyring_fpr="B420FD3777CCE3A7F0076B55C85668DF69375001"

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
apt_srcs_file="/etc/apt/sources.list.d/spotify.sources"

tee /etc/apt/sources.list.d/spotify.sources <<EOF
Types: deb
URIs: https://repository.spotify.com/
Suites: stable
Components: non-free
Signed-By: ${keyring_file}
EOF

chattr +i $apt_srcs_file

# install spotify
apt update && apt install spotify-client
