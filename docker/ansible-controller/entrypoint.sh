#!/bin/sh
set -e

mkdir -p /root/.ssh
if [ ! -f /root/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -q -N ''
fi
chmod 600 /root/.ssh/id_rsa
chmod 644 /root/.ssh/id_rsa.pub

exec sleep infinity
