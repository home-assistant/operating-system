#!/bin/bash
set -e

ARCH=
MACHINE=
DATA_IMG="/export/data.ext4"
VERSION_URL="https://version.home-assistant.io/stable.json"
APPARMOR_URL="https://version.home-assistant.io/apparmor.txt"

# Parse
while [[ $# -gt 0 ]]; do
    key=$1
    case $key in 
        --arch)
            ARCH=$2
            shift
            ;;
        --machine)
            MACHINE=$2
            shift
            ;;
        *)
            exit 1
            ;;
    esac
    shift
done

VERSION_JSON="$(curl -s ${VERSION_URL})"

SUPERVISOR=$(echo "${VERSION_JSON}" | jq -e -r --arg arch "${ARCH}" '.images.supervisor | sub("{arch}"; $arch)')
DNS=$(echo "${VERSION_JSON}" | jq -e -r --arg arch "${ARCH}" '.images.dns | sub("{arch}"; $arch)')
AUDIO=$(echo "${VERSION_JSON}" | jq -e -r --arg arch "${ARCH}" '.images.audio | sub("{arch}"; $arch)')
CLI=$(echo "${VERSION_JSON}" | jq -e -r --arg arch "${ARCH}" '.images.cli | sub("{arch}"; $arch)')
MULTICAST=$(echo "${VERSION_JSON}" | jq -e -r --arg arch "${ARCH}" '.images.multicast | sub("{arch}"; $arch)')
OBSERVER=$(echo "${VERSION_JSON}" | jq -e -r --arg arch "${ARCH}" '.images.observer | sub("{arch}"; $arch)')
LANDINGPAGE=$(echo "${VERSION_JSON}" | jq -e -r --arg machine "${MACHINE}" '.images.core | sub("{machine}"; $machine)'):landingpage

SUPERVISOR_VERSION=$(echo "${VERSION_JSON}" | jq -e -r '.supervisor')
DNS_VERSION=$(echo "${VERSION_JSON}" | jq -e -r '.dns')
CLI_VERSION=$(echo "${VERSION_JSON}" | jq -e -r '.cli')
AUDIO_VERSION=$(echo "${VERSION_JSON}" | jq -e -r '.audio')
MULTICAST_VERSION=$(echo "${VERSION_JSON}" | jq -e -r '.multicast')
OBSERVER_VERSION=$(echo "${VERSION_JSON}" | jq -e -r '.observer')

# Make image
truncate --size="1G" "${DATA_IMG}"
mkfs.ext4 -L "hassos-data" -E lazy_itable_init=0,lazy_journal_init=0 ${DATA_IMG}

# Setup local user
if [ "${BUILDER_UID:0}" -ne 0 ] && [ "${BUILDER_GID:0}" -ne 0 ]; then
  groupadd -g "${BUILDER_GID}" builder
  useradd -m -u "${BUILDER_UID}" -g "${BUILDER_GID}" -G docker builder
  chown builder:builder ${DATA_IMG}
fi

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

# Need match with the tag used by OS
docker tag "${SUPERVISOR}:${SUPERVISOR_VERSION}" "homeassistant/${ARCH}-hassio-supervisor:latest"

# Install Plugins
docker pull "${CLI}:${CLI_VERSION}"
docker pull "${DNS}:${DNS_VERSION}"
docker pull "${AUDIO}:${AUDIO_VERSION}"
docker pull "${MULTICAST}:${MULTICAST_VERSION}"
docker pull "${OBSERVER}:${OBSERVER_VERSION}"

# Install landing page
docker pull "${LANDINGPAGE}"

# Setup AppArmor
mkdir -p "/mnt/data/supervisor/apparmor"
curl -sL -o "/mnt/data/supervisor/apparmor/hassio-supervisor" "${APPARMOR_URL}"

# Finish
kill $DOCKER_PID && wait $DOCKER_PID

# Unmount resource
if ! umount /mnt/data; then
    umount -f /mnt/data || echo "umount force fails!"
fi

exit 0
