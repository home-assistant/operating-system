#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Need a buildroot version!"
    exit 1
fi

rm -rf /tmp/buildroot-new
mkdir -p /tmp/buildroot-new

echo "Download new buildroot"
curl -L "https://buildroot.org/downloads/buildroot-${1}.tar.bz2" \
    | tar xvpjf - --strip 1 -C /tmp/buildroot-new 

echo "Install patches"
for patch_file in buildroot-patches/*; do
    echo "Patch: ${patch_file}"
    patch -d /tmp/buildroot-new -p 1 < "${patch_file}";
done

rm -rf buildroot
mv /tmp/buildroot-new buildroot

git add buildroot
git commit -sam "Update buildroot to ${1}"
