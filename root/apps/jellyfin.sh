#!/bin/sh

program_name="jellyfin"

# import keyring
keyring_url="https://repo.jellyfin.org/jellyfin_team.gpg.key"
keyring_file="/etc/apt/keyrings/jellyfin.asc"
keyring_fpr="4918AABC486CA052358D778D49023CD01DE21A7B"

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
apt_srcs_file="/etc/apt/sources.list.d/jellyfin.sources"
os_arch="$( dpkg --print-architecture )"
os_name="$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release )"
os_version_codename="$( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release )"

tee $apt_srcs_file <<EOF
Types: deb
URIs: https://repo.jellyfin.org/${os_name}
Suites: ${os_version_codename}
Components: main
Architectures: ${os_arch}
Signed-By: ${keyring_file}
EOF

chattr +i $apt_srcs_file

# install jellyfin
apt update && apt install -y jellyfin

# works around https://github.com/jellyfin/jellyfin-packaging/issues/37 for now
chown -R jellyfin:adm /etc/jellyfin

# wait for jellyfin to fully startup
sleep 15

# allow inbound local traffic for jellyfin server
ufw allow from 192.168.1.0/24 proto tcp to any port 8096
