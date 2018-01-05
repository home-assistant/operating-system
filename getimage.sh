#!/bin/bash
mkdir -p output
DID=$(sudo docker ps | grep "hassbuildroot" | awk '{ print $1 }')
docker cp $DID:/buildroot/buildroot-2017.11.1/output/images/rootfs.iso9660 output/rootfs.iso
docker cp $DID:/buildroot/buildroot-2017.11.1/output/graphs output/graphs
