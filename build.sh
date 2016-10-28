#!/bin/bash
VERSION="1.0"

fpm -s dir -t deb -n undercloud-control-plane -v ${VERSION} --exclude undercloud-control-plan/.git \
 --config-files /etc/undercloud-control-plane/undercloud.conf.yaml \
 -d unicorn -d ruby-sinatra -d ruby-sequel -d sqlite3 -d ruby-sqlite3 \
 undercloud-control-plane/config/undercloud.conf.yaml=/etc/undercloud-control-plane/ undercloud-control-plane=/opt/
