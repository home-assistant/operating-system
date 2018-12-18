#!/bin/bash
modprobe overlayfs

docker build -t hassbuildroot .
docker run -it --rm --privileged -v "$(pwd):/build" -v "${CACHE_DIR:=$HOME/hassos-cache}:/cache" hassbuildroot bash
