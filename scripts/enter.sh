#!/bin/bash
docker build -t hassbuildroot .
docker run -it --rm hassbuildroot /bin/bash
