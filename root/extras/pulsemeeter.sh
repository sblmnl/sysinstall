#!/bin/sh

# download and verify gir1.2-appindicator3-0.1
appindicator_pkg_file="gir1.2-appindicator3-0.1_12.10.1%2B18.04.20180322.1-1mint2_amd64.deb"
appindicator_pkg_url="http://packages.linuxmint.com/pool/upstream/liba/libappindicator/$appindicator_pkg_file"
appindicator_pkg_hash="8bffd7d8b37f40ad2e1ec20cc6c104d0e11702de7ee85b7e8c3922892c82d577"

curl -fsSLO $appindicator_pkg_url

if ! echo "$appindicator_pkg_hash  $appindicator_pkg_url" | sha256sum -c --status -; then
    echo "[ERR] gir1.2-appindicator3-0.1 - checksum verification failed!" >&2
    rm $appindicator_pkg_file
    exit 1
fi

# download and verify pulse-vumeter
pulsevumeter_pkg_file="pulse-vumeter-v0.11.tar.gz"
pulsevumeter_pkg_url="https://github.com/theRealCarneiro/pulse-vumeter/archive/refs/tags/v0.11.tar.gz"
pulsevumeter_pkg_hash="51714f54fb17730cfe0ffaac63182d68b8a1775de4664991b76d4c840423ec7c"
pulsevumeter_pkg_ext_dir="pulse-vumeter-0.11"

curl -fsSLo $pulsevumeter_pkg_file $pulsevumeter_pkg_url

if ! echo "$pulsevumeter_pkg_hash  $pulsevumeter_pkg_file" | sha256sum -c --status -; then
    echo "[ERR] pulse-vumeter - checksum verificated failed!" >&2
    rm $appindicator_pkg_file $pulsevumeter_pkg_file
    exit 1
fi

# download and verify pulsemeeter
pulsemeeter_release_version="1.2.14"
pulsemeeter_release_tag="v$pulsemeeter_release_tag"
pulsemeeter_release_pkg_file="$pulsemeeter_release_tag.tar.gz"
pulsemeeter_release_pkg_url="https://github.com/theRealCarneiro/pulsemeeter/archive/refs/tags/$pulsemeeter_release_pkg_file"
pulsemeeter_release_pkg_hash="453eb3edbf1389d030c4cb1ef338dc5e23419c89999a6f6fcf1b9c9cfa5e0c73"
pulsemeeter_release_pkg_ext_dir="pulsemeeter-$pulsemeeter_release_version"

curl -fsSLo $pulsemeeter_release_pkg_file $pulsemeeter_release_pkg_url

if ! echo "$pulsemeeter_release_pkg_file  $pulsemeeter_release_pkg_hash" | sha256sum -c --status -; then
    echo "[ERR] pulsemeeter - checksum verificated failed!" >&2
    rm $appindicator_pkg_file $pulsevumeter_pkg_file $pulsemeeter_release_pkg_file
    exit 1
fi

original_dir=$(pwd)

# install gir1.2-appindicator3-0.1
apt install -y ./$appindicator_pkg_file
rm $appindicator_pkg_file

# install pulse-vumeter
apt install -y libpulse-dev
tar xf $pulsevumeter_pkg_file
cd $pulsevumeter_pkg_ext_dir
make
make install
cd $original_dir
rm -rf $pulsevumeter_pkg_file $pulsevumeter_pkg_ext_dir

# install pulsemeeter
cd $pulsemeeter_release_pkg_ext_dir
pip install . --break-system-packages
cd $original_dir
rm -rf $pulsemeeter_release_pkg_file $pulsemeeter_release_pkg_ext_dir
