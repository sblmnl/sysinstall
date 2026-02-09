#!/bin/sh

apt install -y keyd

tee /etc/keyd/default.conf <<EOF
[ids]

3553:c011:4eaf5201

[main]

a = playpause
b = previoussong
c = nextsong
EOF
