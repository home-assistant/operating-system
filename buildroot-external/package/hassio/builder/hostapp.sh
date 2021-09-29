#!/bin/bash
set -e

ARCH=
MACHINE=
DATA_IMG="/export/data.ext4"
APPARMOR_URL="https://version.home-assistant.io/apparmor.txt"

# Make image
truncate --size="1280M" "${DATA_IMG}"
mkfs.ext4 -L "hassos-data" -E lazy_itable_init=0,lazy_journal_init=0 ${DATA_IMG}

# Setup local user
if [ "${BUILDER_UID:0}" -ne 0 ] && [ "${BUILDER_GID:0}" -ne 0 ]; then
  groupadd -g "${BUILDER_GID}" builder
  useradd -m -u "${BUILDER_UID}" -g "${BUILDER_GID}" -G docker builder
  chown builder:builder ${DATA_IMG}
fi

# Mount / init file structs
mkdir -p /mnt/data/
mount -o loop,discard ${DATA_IMG} /mnt/data
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
for image in /images/*.tar; do
	docker load --input "${image}"
	docker image prune --force
done

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
