#!/bin/bash

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <cert_path> <key_path>"
    exit 1
fi

cert=$1
key=$2

openssl req -x509 -newkey rsa:4096 -keyout "${key}" \
                -out "${cert}" -days 3650 -nodes \
                -subj "/O=HassOS/CN=HassOS Self-signed Development Certificate"
