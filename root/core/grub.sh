#!/bin/sh

tee /etc/default/grub <<EOF
GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=\`lsb_release -i -s 2> /dev/null || echo Debian\`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX=""
GRUB_DISABLE_OS_PROBER=false
GRUB_GFXMODE="2560x1440x32"
GRUB_GFXPAYLOAD="2560x1440x32"
EOF

line=$(grep -n 'if \[ "x${GRUB_GFXMODE' /etc/grub.d/00_header | cut -d : -f1)
sed -i "$(echo $line)s/auto/2560x1440x32/" /etc/grub.d/00_header

line=$(($line+1))
sed -i "$line i if [ \"x\${GRUB_GFXPAYLOAD}\" = \"x\" ] ; then GRUB_GFXPAYLOAD=2560x1440x32 ; fi" /etc/grub.d/00_header

line=$(echo "$(grep -n 'set gfxmode' /etc/grub.d/00_header | cut -d : -f1) + 1" | bc)
sed -i "$line i \ \ set gfxpayload=\${GRUB_GFXPAYLOAD}" /etc/grub.d/00_header

update-grub
