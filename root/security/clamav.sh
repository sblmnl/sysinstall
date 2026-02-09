#!/bin/sh

apt install -y \
   clamav \
   clamav-daemon \
   clamav-freshclam \
   clamdscan \
   clamtk

systemctl disable clamav-daemon

rm /var/log/clamav/clamav.log /var/log/clamav/freshclam.log

freshclam

systemctl enable --now clamav-freshclam
