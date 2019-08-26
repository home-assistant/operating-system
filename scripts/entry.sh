#!/bin/bash
set -e

USER="root"

# Run dockerd
dockerd -s vfs &> /dev/null &

# Setup local user
if [ "${BUILDER_UID:-0}" -ne 0 ] && [ "${BUILDER_GID:-0}" -ne 0 ]; then
  groupadd -g "${BUILDER_GID}" builder
  useradd -m -u "${BUILDER_UID}" -g "${BUILDER_GID}" -G docker,sudo builder
  echo "builder ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
  USER="builder"
fi

if CMD="$(command -v "$1")"; then
  shift
  sudo -H -u ${USER} "$CMD" "$@"
else
  echo "Command not found: $1"
  exit 1
fi
