#!/bin/bash
set -e

for patch_file in buildroot-patches/*; do
      patch -d buildroot/ -p1 < ${patch_file};
done
