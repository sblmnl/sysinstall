#!/bin/sh

apt install -y ufw

ufw enable

# implicit deny
ufw default deny incoming
ufw default allow outgoing
