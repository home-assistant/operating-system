#!/bin/bash
docker build -t hassbuildroot .
docker run -it --rm --privileged -v /dev/mapper:/dev/mapper -v "$(pwd):/build" hassbuildroot bash
