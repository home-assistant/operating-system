#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Need a version!"
    exit 1
fi

sed -i "s/CLI_VERSION=\".*\"/CLI_VERSION=\"$1\"/g" buildroot-external/configs/*
git commit -m "OS: Update CLI $1" buildroot-external/configs/*
