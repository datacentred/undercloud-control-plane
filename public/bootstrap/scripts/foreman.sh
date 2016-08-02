#!/bin/bash
unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY


apt-get -y install ca-certificates
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb

echo "deb http://deb.theforeman.org/ trusty 1.11" > /etc/apt/sources.list.d/foreman.list
echo "deb http://deb.theforeman.org/ plugins 1.11" >> /etc/apt/sources.list.d/foreman.list
wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add -

apt-get update 


apt-get install foreman-installer git puppet -y
#git clone https://github.com/datacentred/bootstrap.git /tmp/bootstrap
git clone git://10.20.254.10:/ /tmp/bootstrap
#puppet apply ./site.pp --modulepath=`pwd`

cp /tmp/bootstrap/conf/foreman-answers /etc/foreman-installer/scenarios.d/foreman-answers.json
foreman-installer

cat << EOT > /etc/network/interfaces
# The loopback network interface
auto lo br0
iface lo inet loopback

iface eth0 inet manual

iface br0 inet dhcp
  bridge_ports eth0
EOT



curl --noproxy '*' -X POST -d "$(/usr/bin/facter --json)" http://10.20.254.10:4567/installed

