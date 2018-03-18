#!/bin/bash
docker build -t hassbuildroot .
docker run -it --rm -v "$(pwd):/build" hassbuildroot /bin/bash
