#!/bin/sh
set -e

mkdir -p /root/.ssh
chmod 700 /root/.ssh

for _ in $(seq 1 60); do
  [ -f /root/.ssh/id_ed25519.pub ] && break
  sleep 1
done
[ -f /root/.ssh/id_ed25519.pub ] || { echo "Timeout waiting for ansible_host key"; exit 1; }

cat /root/.ssh/id_ed25519.pub > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
