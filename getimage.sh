#!/bin/bash
mkdir -p output
DID=$(docker ps | grep "hassbuildroot" | awk '{ print $1 }')
docker cp $DID:/buildroot/buildroot-2017.11.2/output/images/rootfs.iso9660 output/rootfs.iso
docker cp $DID:/buildroot/buildroot-2017.11.2/output/graphs output/graphs
