#!/usr/bin/env bash

set -e
set -u
set -o pipefail

arch=$1
machine=$2
version_json=$3
image_json_name=$4
dl_dir=$5
dst_dir=$6

retry() {
	local retries="$1"
	local cmd=$2

	local output
	output=$(eval "$cmd")
	local rc=$?

	# shellcheck disable=SC2086
	if [ $rc -ne 0 ] && [ $retries -gt 0 ]; then
		echo "Retrying \"$cmd\" $retries more times..." >&2
		sleep 3s
		# shellcheck disable=SC2004
		retry $(($retries - 1)) "$cmd"
	else
		echo "$output"
		return $rc
	fi
}

image_name=$(jq -e -r --arg image_json_name "${image_json_name}" \
	--arg arch "${arch}" --arg machine "${machine}" \
	'.images[$image_json_name] | sub("{arch}"; $arch) | sub("{machine}"; $machine)' \
	< "${version_json}")
image_tag=$(jq -e -r --arg image_json_name "${image_json_name}" \
	'.[$image_json_name]' < "${version_json}")
full_image_name="${image_name}:${image_tag}"

image_digest=$(retry 3 "skopeo inspect 'docker://${full_image_name}' | jq -r '.Digest'")

# Cleanup image name file name use
image_file_name="${full_image_name//[:\/]/_}@${image_digest//[:\/]/_}"
image_file_path="${dl_dir}/${image_file_name}.tar"
dst_image_file_path="${dst_dir}/${image_file_name}.tar"

(
	# Use file locking to avoid race condition
	flock --verbose 3
	if [ ! -f "${image_file_path}" ]
	then
		echo "Fetching image: ${full_image_name} (digest ${image_digest})"
		retry 3 "skopeo copy 'docker://${image_name}@${image_digest}' 'docker-archive:${image_file_path}:${full_image_name}'"
	else
		echo "Skipping download of existing image: ${full_image_name} (digest ${image_digest})"
	fi

	cp "${image_file_path}" "${dst_image_file_path}"
) 3>"${image_file_path}.lock"
