#!/bin/bash
set -e

USER="root"

loop_devices_usable() {
  local capeff

  # Opening /dev/loop-control fails without --privileged and in rootless Docker or Podman
  : 2> /dev/null < /dev/loop-control || return 1

  # Mounting a loop device needs CAP_SYS_ADMIN, which is bit 21 of CapEff
  capeff="$(awk '/^CapEff:/ {print $2}' /proc/self/status)"
  (( 0x${capeff} >> 21 & 1 ))
}

if ! loop_devices_usable; then
  echo "WARNING: Loop devices are not usable, building the data partition will fail."
  echo "Make sure the container runs with --privileged in rootful Docker and the loop module is loaded."
fi

# Run dockerd
dockerd -s vfs &> /dev/null &


# Setup local group, if not existing
if [ "${BUILDER_GID:-0}" -ne 0 ] && ! getent group "${BUILDER_GID:-0}"; then
  groupadd -g "${BUILDER_GID}" builder
fi

# Setup local user
if [ "${BUILDER_UID:-0}" -ne 0 ]; then
  useradd -m -u "${BUILDER_UID}" -g "${BUILDER_GID}" -G docker,sudo builder
  echo "builder ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
  # Make sure cache is accessible by builder
  chown "${BUILDER_UID}:${BUILDER_GID}" /cache
  # Make sure output is accessible by builder (if anonymous volume is used)
  chown "${BUILDER_UID}:${BUILDER_GID}" /build/output || true
  USER="builder"
fi

if CMD="$(command -v "$1")"; then
  shift
  sudo -H -u ${USER} "$CMD" "$@"
else
  echo "Command not found: $1"
  exit 1
fi
