#!/bin/sh

# This script enables routing between the ethernet port connected to the switch
# and the ethernet port connected to the internet.
# dnsmasq should also run for dhcp.

# The ethernet port connected to the switch
SWITCH_ETH=eth1

# The ethernet port connected to the internet
INTERNET_ETH=eth0

set -e

# Give ourself an ip address and enable the switch ethernet port
ip addr add 10.0.1.1/24 dev "$SWITCH_ETH"
ip link set "$SWITCH_ETH" up

# Allow routing through switch ethernet port to the internet ethernet port
iptables -A FORWARD -o "$INTERNET_ETH" -i "$SWITCH_ETH" -s "10.0.1.0/24" -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -F POSTROUTING
iptables -t nat -A POSTROUTING -o "$INTERNET_ETH" -j MASQUERADE

# Allow forwarding packets
sysctl net.ipv4.ip_forward=1

