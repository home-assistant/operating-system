#!/bin/bash
DID=$(sudo docker ps | grep "hassbuildroot" | awk '{ print $1 }')
docker cp $DID:/buildroot/buildroot-2017.11.1/.config vm/buildroot.config
docker cp $DID:/buildroot/buildroot-2017.11.1/linux.config vm/linux.config

