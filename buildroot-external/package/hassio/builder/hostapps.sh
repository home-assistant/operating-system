#!/bin/bash
set -e

SUPERVISOR=""
SUPERVISOR_VERSION=""
SUPERVISOR_ARGS=""
CLI=""
CLI_VERSION=""
CLI_ARGS=""
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
    if [ $((endtime - starttime)) -le 30 ]; then
        sleep 1
        endtime=$(date +%s)
    else
        exit 1
    fi
done

# Install supervisor
docker pull ${SUPERVISOR}:${SUPERVISOR_VERSION}
docker tag ${SUPERVISOR}:${SUPERVISOR_VERSION} ${SUPERVISOR}:latest

# Install cli
docker pull ${CLI}:${CLI_VERSION}
docker tag ${CLI}:${CLI_VERSION} ${CLI}:latest

# Write config
echo << EOF
{
    "supervisor": "${SUPERVISOR}",
    "supervisor_args": "${SUPERVISOR_ARGS}",
    "cli": "${CLI}",
    "cli_args": "${CLI_ARGS}"
}
EOF > /mnt/hassio.json

# Finish
kill -TERM $DOCKER_PID && wait $DOCKER_PID && umount /mnt
