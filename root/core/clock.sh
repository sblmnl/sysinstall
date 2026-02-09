#!/bin/sh

# enable time sync w/ ntp
apt install -y systemd-timesyncd
systemctl enable systemd-timesyncd
