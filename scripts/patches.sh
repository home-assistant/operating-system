#!/bin/bash
set -e

BUILDROOT_PATCHES="buildroot-patches/"

for patch in "$BUILDROOT_PATCHES"; do
      patch -d buildroot -p1 < $${patch};
done
