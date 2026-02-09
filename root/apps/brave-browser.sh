#!/bin/sh

program_name="brave-browser"

# import keyring
keyring_url="https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg"
keyring_file="/etc/apt/keyrings/brave-browser.gpg"
keyring_fpr="DBF1A116C220B8C7164F98230686B78420038257 47D32A74E9A9E013A4B4926C68D513D36A73CD96 B2A3DCA350E67256740DF904DE4EC67BE4B0DCA0"

curl -fsSLo $keyring_file $keyring_url

if [ $(gpg --show-keys --with-colons $keyring_file \
    | awk -F: '$1=="pub",($1!="pub"&&$2=="-"){if($1=="fpr"){print$10}}' \
    | tr '\n' ' ' \
    | sed 's/ $//') != $keyring_fpr ]
then
    echo "[ERR] brave - keyring fingerprint verification failed!" >&2
    rm $keyring_file
    exit 1
fi

# add apt repository
os_arch="$( dpkg --print-architecture )"

tee /etc/apt/sources.list.d/brave-browser-release.sources <<EOF
Types: deb
URIs: https://brave-browser-apt-release.s3.brave.com
Suites: stable
Components: main
Architectures: ${os_arch}
Signed-By: ${keyring_file}
EOF

# install brave
apt update && apt install -y brave-browser
