#!/bin/bash
set -e

DATA_IMG="/export/data.img"

# Make image
dd if=/dev/zero of=${DATA_IMG} bs=1024M count=1
mkfs.ext4 -E lazy_itable_init=0,lazy_journal_init=0 -i 8192 ${DATA_IMG}

# Mount / init file structs
mount -o loop ${DATA_IMG} /mnt
mkdir -p /mnt/docker
mkdir -p /mnt/supervisor
mkdir -p /mnt/cli

# Run dockerd
dockerd -s overlay2 -g /mnt/docker 2> /dev/null &
DOCKER_PID=$!

starttime="$(date +%s)"
endtime="$(date +%s)"
until docker info >/dev/null 2>&1; do
    if [ $((endtime - starttime)) -le $DOCKER_TIMEOUT ]; then
        sleep 1
        endtime=$(date +%s)
    else
        exit 1
    fi
done

