#!/bin/bash
DID=$(docker ps | grep "hassbuildroot" | awk '{ print $1 }')
docker cp $DID:/buildroot/buildroot-2017.11.2/.config vm/buildroot.config
docker cp $DID:/buildroot/buildroot-2017.11.2/linux.config vm/linux.config

