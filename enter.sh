#!/bin/bash
docker build -t hassbuildroot .
docker run -it --rm -v "$(pwd)/buildroot-external":/build/buildroot-external hassbuildroot /bin/bash
