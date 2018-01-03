#!/bin/bash
DID=$(sudo docker ps | grep "hassbuildroot" | awk '{ print $1 }')
docker cp $DID:/buildroot/buildroot-2017.11.1/.config ~/hassbuild/vm/buildroot.config
docker cp $DID:/buildroot/buildroot-2017.11.1/linux.config ~/hassbuild/vm/linux.config

