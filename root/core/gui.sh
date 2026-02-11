#!/bin/sh

# install xorg, i3, rofi, polybar and picom
apt install -y \
    xorg \
    i3 \
    picom \
    rofi \
    polybar \
    xdg-user-dirs-gtk

# install fairyglade/ly

## prereq: install minisign

apt install -y minisign

## prereq: setup zig

zig_sig_key="RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U"
zig_pkg_version="0.15.2"
zig_pkg_file="zig-x86_64-linux-$zig_pkg_version.tar.xz"
zig_pkg_url="https://ziglang.org/download/$zig_pkg_version/$zig_pkg_file"
zig_pkg_sig_url="$zig_pkg_url.minisig"
zig_pkg_sig_file="$zig_pkg_file.minisig"
zig_ext_dir="zig-x86_64-linux-$zig_pkg_version"

curl -fsSLO $zig_pkg_url
curl -fsSLO $zig_pkg_sig_url

if ! minisign -V -m $zig_pkg_file -P $zig_sig_key -q; then
    echo "[ERR] ly - zig signature verification failed!" >&2
    rm $zig_pkg_file $zig_pkg_sig_file
    apt purge --autoremove minisign
    exit 1
fi

apt purge --autoremove minisign
tar xf $zig_pkg_file
rm $zig_pkg_file $zig_pkg_sig_file

## main: install ly

ly_release_version="1.3.2"
ly_release_tag="v$ly_release_version"
ly_pkg_file="ly-$ly_release_version.tar.gz"
ly_pkg_url="https://github.com/fairyglade/ly/archive/refs/tags/$ly_release_tag.tar.gz"
ly_pkg_hash="73254acc3c8974a24dbf308e77b096ad6fa2c8818da4d5b865173225602e87d1"
ly_ext_dir="ly-$ly_release_version"

curl -fsSLo $ly_pkg_file $ly_pkg_url

if ! echo "$ly_pkg_hash  $ly_pkg_file" | sha256sum -c --status -; then
    echo "[ERR] ly - checksum verification failed!" >&2
    rm -rf $zig_pkg_file* $zig_ext_dir $ly_pkg_file
    exit 1
fi

apt install -y libpam0g-dev libxcb-xkb-dev brightnessctl

tar xf $ly_pkg_file
rm $ly_pkg_file

cd $ly_ext_dir

../$zig_ext_dir/zig build installexe -Dinit_system=systemd

cd ..

systemctl enable ly@tty2.service
systemctl disable getty@tty2.service

rm -rf $zig_ext_dir $ly_ext_dir
