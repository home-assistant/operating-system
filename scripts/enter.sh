#!/bin/bash
docker build -t hassbuildroot .
docker run -it --rm --privileged -d /dev/mapper:/dev/mapper -v "$(pwd):/build" hassbuildroot bash
