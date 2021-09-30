#!/bin/sh
set -e

APPARMOR_URL="https://version.home-assistant.io/apparmor.txt"

# Install supervisor
for image in /build/images/*.tar; do
	docker load --input "${image}"
done

# Tag the Supervisor how the OS expects it to be tagged
supervisor=$(docker images --filter "label=io.hass.type=supervisor" --quiet)
arch=$(docker inspect --format '{{ index .Config.Labels "io.hass.arch" }}' "${supervisor}")
docker tag "${supervisor}" "homeassistant/${arch}-hassio-supervisor:latest"

# Setup AppArmor
mkdir -p "/data/supervisor/apparmor"
wget -O "/data/supervisor/apparmor/hassio-supervisor" "${APPARMOR_URL}"

