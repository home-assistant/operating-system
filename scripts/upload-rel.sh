#!/bin/bash
set -e

if [ -z "${1}" ] || [ -z "${2}" ]; then
    echo "[Error] Parameter error"
    exit 1
fi

# Define variables.
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/home-assistant/hassos"
GH_TAGS="$GH_REPO/releases/tags/${2}"
AUTH="Authorization: token ${1}"

# Validate token.
if ! curl -o /dev/null -sH "$AUTH" $GH_REPO; then
    echo "[Error] Invalid repo, token or network issue!"
    exit 1
fi

# Read asset tags.
id=$(curl -sH "$AUTH" $GH_TAGS | jq -e ".id // empty")

# Get ID of the asset based on given filename.
if [ -z "$id" ]; then
    echo "[Error] Failed to get release id for tag: ${2}"
    exit 1
fi

# Upload asset
echo "[Info] Start Uploading asset... "

for filename in release/*.{gz,raucb}; do
    echo "[Info] Start upload ${filename}"

    # Construct url
    GH_ASSET="https://uploads.github.com/repos/home-assistant/hassos/releases/$id/assets?name=$(basename $filename)"

    curl "$GITHUB_OAUTH_BASIC" --data-binary @"$filename" -H "${AUTH}" -H "Content-Type: application/octet-stream" $GH_ASSET

    echo "[Info] Upload ${filename} done"
done

