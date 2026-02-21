#!/bin/sh

program_name="spotify"

# import keyring
keyring_url="https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc"
keyring_file="/etc/apt/keyrings/spotify.asc"
keyring_fpr="E1096BCBFF6D418796DE78515384CE82BA52C83A"

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

tee /etc/apt/sources.list.d/spotify.list <<EOF
# THIS FILE EXISTS TO PREVENT SPOTIFY FROM SETTING ITS OWN SOURCES
EOF

chattr +i /etc/apt/sources.list.d/spotify.list

tee $apt_srcs_file <<EOF
Types: deb
URIs: https://repository.spotify.com/
Suites: stable
Components: non-free
Signed-By: ${keyring_file}
EOF

chattr +i $apt_srcs_file

# install spotify
apt update && apt install spotify-client

# add desktop entry
tee /usr/share/applications/spotify.desktop <<EOF
[Desktop Entry]
Name=Spotify
GenericName=Music Player
Comment=Listen to music using Spotify
Icon=spotify-client
Exec=spotify %U
TryExec=spotify
Terminal=false
Type=Application
Categories=Qt;Audio;Music;Player;AudioVideo
MimeType=x-scheme-handler/spotify
EOF
