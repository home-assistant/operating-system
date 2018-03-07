#!/bin/bash
mkdir -p output
DID=$(docker ps | grep "hassbuildroot" | awk '{ print $1 }')
docker cp $DID:/build/buildroot/output/images/rootfs.iso9660 output/rootfs.iso
docker cp $DID:/build/buildroot/output/graphs output/graphs
