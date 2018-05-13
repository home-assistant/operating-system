#!/bin/bash
set -e

SUPERVISOR=""
SUPERVISOR_VERSION=""
SUPERVISOR_ARGS=""
SUPERVISOR_PROFILE=""
CLI=""
CLI_VERSION=""
CLI_ARGS=""
CLI_PROFILE=""
APPARMOR=""
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
        --supervisor-profile)
            SUPERVISOR_PROFILE=$2
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
        --cli-profile)
            CLI_PROFILE=$2
            shift
            ;;
        --apparmor)
            APPARMOR=$2
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
mkdir -p /mnt/data/
mount -o loop ${DATA_IMG} /mnt/data
mkdir -p /mnt/data/docker

# Run dockerd
dockerd -s overlay2 -g /mnt/data/docker &
DOCKER_PID=$!

DOCKER_COUNT=0
until docker info >/dev/null 2>&1; do
    if [ ${DOCKER_COUNT} -gt 30 ]; then
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
cat > /mnt/data/hassio.json <<- EOF
{
    "supervisor": "${SUPERVISOR}",
    "supervisor_args": "${SUPERVISOR_ARGS}",
    "supervisor_apparmor": "${SUPERVISOR_PROFILE}",
    "cli": "${CLI}",
    "cli_args": "${CLI_ARGS}",
    "cli_apparmor": "${CLI_PROFILE}",
    "apparmor": "${APPARMOR}"
}
EOF

# Setup AppArmor
if [ ! -z "${APPARMOR}" ]; then
    mkdir -p /mnt/data/${APPARMOR}
    cp -f /apparmor/* /mnt/data/${APPARMOR}/
fi

# Finish
kill -TERM $DOCKER_PID && wait $DOCKER_PID && umount /mnt/data
