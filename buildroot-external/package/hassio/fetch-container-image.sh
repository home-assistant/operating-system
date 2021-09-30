#!/usr/bin/env bash

arch=$1
machine=$2
version_json=$3
image_name=$4
dl_dir=$5
dst_dir=$6

set -e

full_image_name=$(jq -e -r --arg arch "${arch}" --arg machine "${machine}" \
	--arg image_name "${image_name}" \
	'.images[$image_name] + ":" + .[$image_name] | sub("{arch}"; $arch) |
	sub("{machine}"; $machine)' < "${version_json}")

# Cleanup image name file name use
image_file_name=${full_image_name//[:\/]/_}
image_file_path="${dl_dir}/${image_file_name}.tar"
dst_image_file_path="${dst_dir}/${image_file_name}.tar"

if [ -f "${image_file_path}" ]
then
	echo "Skipping download of existing image: ${full_image_name}"
	cp "${image_file_path}" "${dst_image_file_path}"
	exit 0
fi

echo "Fetching image: ${full_image_name}"
skopeo copy "docker://${full_image_name}" "docker-archive:${image_file_path}:${full_image_name}"
cp "${image_file_path}" "${dst_image_file_path}"
