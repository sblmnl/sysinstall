#!/bin/sh

program_name="veracrypt"

# verify and import signing key
sig_key_url="https://amcrypto.jp/VeraCrypt/VeraCrypt_PGP_public_key.asc"
sig_key_file="VeraCrypt_PGP_public_key.asc"
sig_key_fpr="5069A233D55A0EEB174A5FC3821ACD02680D16DE"

curl -fsSLo $sig_key_file $sig_key_url

if [ $(gpg --show-keys --with-colons $sig_key_file \
    | awk -F: '$1=="pub",($1!="pub"&&$2=="-"){if($1=="fpr"){print$10}}' \
    | tr '\n' ' ' \
    | sed 's/ $//') != $sig_key_fpr ]
then
    echo "[ERR] $program_name - signing key fingerprint verification failed!" >&2
    rm $sig_key_file
    exit 1
fi

gpg --import $sig_key_file
rm $sig_key_file

# download release
release_version="1.26.24"
release_tag="VeraCrypt_$release_version"
release_base_url="https://github.com/veracrypt/VeraCrypt/releases/download/$release_tag"
release_pkg_file="veracrypt-$release_version-Debian-13-amd64.deb"
release_sig_file="$release_pkg_file.sig"

curl -fsSLO "$release_base_url/$release_pkg_file"
curl -fsSLO "$release_base_url/$release_sig_file"

# verify signature
if ! gpg --verify $release_sig_file; then
    echo "[ERR] $program_name - signature verification failed!" >&2
    rm $release_pkg_file $release_sig_file
    exit 1
fi

# install veracrypt
apt install -y pcscd
apt install -y -f $release_pkg_file

# cleanup
rm $release_pkg_file $release_sig_file
