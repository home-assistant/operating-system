#!/bin/bash
modprobe overlayfs

docker build -t hassbuildroot .
docker run -it --rm --privileged -v $(pwd):/build -v ${CACHE_DIR:=~/hassos-cache}:/cache hassbuildroot bash
