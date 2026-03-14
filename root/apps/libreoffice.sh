#!/bin/sh

program_name="libreoffice"

# import public release signing key
sig_key_server="hkps://pgp.mit.edu"
sig_key_id="0xF434A1EFAFEEAEA3"
sig_key_fpr="C2839ECAD9408FBE9531C3E9F434A1EFAFEEAEA3"

gpg --keyserver $sig_key_server --recv-keys $sig_key_id

if [ $(gpg --fingerprint --with-colons $sig_key_fpr \
    | awk -F: '$1=="pub",($1!="pub"&&$2=="-"){if($1=="fpr"){print$10}}' \
    | tr '\n' ' ' \
    | sed 's/ $//') != $sig_key_fpr ]
then
    echo "[ERR] $program_name - signing key fingerprint verification failed!" >&2
    gpg --batch --yes --delete-keys $sig_key_fpr
    exit 1
fi

echo "$sig_key_fpr:4:" | gpg --import-ownertrust

# download release
release_version="26.2.1"
release_base_url="https://download.documentfoundation.org/libreoffice/stable/$release_version/deb/x86_64/"
release_pkg_file="LibreOffice_${release_version}_Linux_x86-64_deb.tar.gz"
release_sig_file="LibreOffice_${release_version}_Linux_x86-64_deb.tar.gz.asc"
release_pkg_ext_dir="LibreOffice_26.2.1.2_Linux_x86-64_deb"

curl -fsSLO "$release_base_url/$release_pkg_file"
curl -fsSLO "$release_base_url/$release_sig_file"

# verify signature
if ! gpg --assert-signer $sig_key_fpr --verify $release_sig_file $release_pkg_file; then
    echo "[ERR] $program_name - signature verification failed!" >&2
    rm $release_pkg_file $release_sig_file
    gpg --batch --yes --delete-keys $sig_key_fpr
    exit 1
fi

# extract tarball and install libreoffice
tar xf $release_pkg_file
original_dir=$(pwd)
cd ./$release_pkg_ext_dir/DEBS
dpkg -i *.deb
cd $original_dir

# cleanup
gpg --batch --yes --delete-keys $sig_key_fpr
rm -rf $release_pkg_ext_dir $release_pkg_file $release_sig_file
