#!/bin/bash
docker build -t hassbuildroot .
docker run -it --rm -v .:/build hassbuildroot /bin/bash
