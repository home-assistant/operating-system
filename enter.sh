#!/bin/bash
docker build -t hassbuildroot -f Dockerfile.vm .
docker run -it --rm hassbuildroot /bin/bash
