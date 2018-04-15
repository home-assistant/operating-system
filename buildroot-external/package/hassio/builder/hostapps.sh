#!/bin/bash
set -e

DATA_IMG="/export/data.img"

# Make image
dd if=/dev/zero of=${DATA_IMG} bs=1M count=1024
mkfs.ext4 -E lazy_itable_init=0,lazy_journal_init=0 -i 8192 ${DATA_IMG}

# Mount / init file structs
mount -o loop ${DATA_IMG} /mnt
mkdir -p /mnt/docker
mkdir -p /mnt/supervisor
mkdir -p /mnt/cli
