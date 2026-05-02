#!/bin/sh
set -e

mkdir -p /root/.ssh
if [ ! -f /root/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -q -N ''
fi
chmod 600 /root/.ssh/id_ed25519
chmod 644 /root/.ssh/id_ed25519.pub

exec sleep infinity
