#!/bin/bash
set -e

BUILDER_UID="$(id -u)"
BUILDER_GID="$(id -g)"
CACHE_DIR="${CACHE_DIR:-$HOME/hassos-cache}"

if [ "$BUILDER_UID" -eq "0" ] || [ "$BUILDER_GID" == "0" ]; then
  echo "ERROR: Please run this script as a regular (non-root) user with sudo privileges."
  exit 1
fi

mkdir -p "${CACHE_DIR}"
docker build -t hassos:local .

if [ ! -f buildroot/Makefile ]; then
  # Initialize git submodule
  git submodule update --init
fi

if command -v losetup >/dev/null && [ ! -e /dev/loop0 ]; then
  # Make sure loop devices are present before starting the container
  sudo losetup -f > /dev/null
fi

docker run -it --rm --privileged \
  -v "$(pwd):/build" -v "${CACHE_DIR}:/cache" \
  -e BUILDER_UID="${BUILDER_UID}" -e BUILDER_GID="${BUILDER_GID}" \
  hassos:local "${@:-bash}"
