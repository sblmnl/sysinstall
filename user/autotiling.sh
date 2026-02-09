#!/bin/sh

checksum="3270a28de977f375c80984ef50f7433cb03cfdf198b079ae9c80d1513f0e9176"

curl -fsSLo autotiling.tar.gz https://github.com/nwg-piotr/autotiling/archive/refs/tags/v1.9.3.tar.gz

if ! echo "$checksum  autotiling.tar.gz" | sha256sum -c --status -; then
    echo "[ERR] autotiling - checksum verification failed!" >&2
    exit 1
fi

tar xf autotiling.tar.gz

pip install --user ./autotiling-1.9.3

rm -rf autotiling.tar.gz autotiling-1.9.3
