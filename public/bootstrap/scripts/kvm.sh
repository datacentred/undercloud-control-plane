#!/bin/bash
unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY

cat << EOT > /etc/network/interfaces
## The loopback network interface
auto lo br0
iface lo inet loopback

iface eth0 inet manual

iface br0 inet dhcp
  bridge_ports eth0
EOT

curl --noproxy '*' -X POST -d "$(/usr/bin/facter --json)" http://10.20.254.10:4567/installed 

