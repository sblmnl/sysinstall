#!/bin/sh

program_name="firefox"

# import keyring
keyring_url="https://packages.mozilla.org/apt/repo-signing-key.gpg"
keyring_file="/etc/apt/keyrings/mozilla.asc"
keyring_fpr="35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3"

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
tee /etc/apt/sources.list.d/mozilla.sources <<EOF
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: ${keyring_file}
EOF

# configure apt to prioritize the mozilla repository
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | tee /etc/apt/preferences.d/mozilla

# install firefox
apt update && apt install -y firefox
