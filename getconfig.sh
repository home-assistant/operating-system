#!/bin/bash
DID=$(docker ps | grep "hassbuildroot" | awk '{ print $1 }')
docker cp -yr $DID:/buildroot/buildroot-external buildroot-external 
