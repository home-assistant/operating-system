#!/bin/bash
docker build -t hassbuildroot .
docker run -it --rm --privileged -v "$(pwd):/build" hassbuildroot bash
