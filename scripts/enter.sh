#!/bin/bash
BUILDER_UID="$(id -u)"
BUILDER_GID="$(id -g)"

sudo docker build -t hassos:local .
sudo docker run -it --rm --privileged \
  -v "$(pwd):/build" -v "${CACHE_DIR:=$HOME/hassos-cache}:/cache" \
  -e BUILDER_UID="${BUILDER_UID}" -e BUILDER_GID="${BUILDER_GID}" \
  hassos:local bash
