#!/bin/sh

apt update
apt upgrade && apt dist-upgrade

apt install dnsmasq

systemctl stop dnsmasq

# Copy in files
cp files/setup-internal-network.sh /bin/
cp files/setup-internal-network.service /etc/systemd/system/
cp files/dnsmasq.conf /etc/

# Inform systemd about the new service file
systemctl daemon-reload

# Enable and start services
systemctl enable --now setup-internal-network.service
systemctl enable --now dnsmasq.service

