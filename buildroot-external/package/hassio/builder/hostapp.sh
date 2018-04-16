#!/bin/bash
set -e

SUPERVISOR=""
SUPERVISOR_VERSION=""
SUPERVISOR_ARGS=""
CLI=""
CLI_VERSION=""
CLI_ARGS=""
DATA_IMG="/export/data.ext4"

# Parse
while [[ $# -gt 0 ]]; do
    key=$1
    case $key in 
        --supervisor)
            SUPERVISOR=$2
            shift
            ;;
        --supervisor-version)
            SUPERVISOR_VERSION=$2
            shift
            ;;
        --supervisor-args)
            SUPERVISOR_ARGS=$2
            shift
            ;;
        --cli)
            CLI=$2
            shift
            ;;
        --cli-version)
            CLI_VERSION=$2
            shift
            ;;
        --cli-args)
            CLI_ARGS=$2
            shift
            ;;
        *)
            exit 1
            ;;
    esac
    shift
done

# Make image
dd if=/dev/zero of=${DATA_IMG} bs=1G count=1
mkfs.ext4 -L "hassio-data" -E lazy_itable_init=0,lazy_journal_init=0 ${DATA_IMG}

# Mount / init file structs
mount -o loop ${DATA_IMG} /mnt
mkdir -p /mnt/docker
mkdir -p /mnt/supervisor
mkdir -p /mnt/cli

# Run dockerd
dockerd -s overlay2 -g /mnt/docker 2> /dev/null &
DOCKER_PID=$!

until docker info >/dev/null 2>&1; do
    DOCKER_COUNT=0
    if [ ! ${DOCKER_COUNT} -gt 30 ]; then
        exit 1
    fi
        
    sleep 1
    DOCKER_COUNT=$((DOCKER_COUNT + 1))
done

# Install supervisor
docker pull "${SUPERVISOR}:${SUPERVISOR_VERSION}"
docker tag "${SUPERVISOR}:${SUPERVISOR_VERSION}" "${SUPERVISOR}:latest"

# Install cli
docker pull "${CLI}:${CLI_VERSION}"
docker tag "${CLI}:${CLI_VERSION}" "${CLI}:latest"

# Write config
cat > /mnt/hassio.json <<- EOF
{
    "supervisor": "${SUPERVISOR}",
    "supervisor_args": "${SUPERVISOR_ARGS}",
    "cli": "${CLI}",
    "cli_args": "${CLI_ARGS}"
}
EOF

# Finish
kill -TERM $DOCKER_PID && wait $DOCKER_PID && umount /mnt
