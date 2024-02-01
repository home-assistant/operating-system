#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Need a kernel version!"
    exit 1
fi

# assume the version is same in all defconfigs, take ova as the reference
current_version=$(grep 'BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE' buildroot-external/configs/ova_defconfig | cut -d '"' -f 2)

# get X.Y.Z tokens of the current and new version
IFS='.' read -r -a current_version_parts <<< "$current_version"
IFS='.' read -r -a new_version_parts <<< "$1"


defconfigs=(buildroot-external/configs/{generic_aarch64,generic_x86_64,ova,tinker,odroid_*,khadas_vim3,green}_defconfig)
sed -i "s/BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE=\".*\"/BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE=\"$1\"/g" "${defconfigs[@]}"
sed -i "s/| \(Open Virtual Appliance\|Generic aarch64\|Generic x86-64\|Tinker Board\|ODROID-.*\|Khadas VIM3\|Home Assistant Green\) | .* |/| \1 | $1 |/g" Documentation/kernel.md

commit_message="Linux: Update kernel to $1"

# get links to changelog if we're only updating the Z part of the version
if [ "${current_version_parts[0]}" == "${new_version_parts[0]}" ] && \
   [ "${current_version_parts[1]}" == "${new_version_parts[1]}" ] && \
   [ "${current_version_parts[2]}" -lt "${new_version_parts[2]}" ]; then

    commit_message="$commit_message"$'\n\n'

    # loop from the current Z + 1 to the new Z
    for (( z = current_version_parts[2] + 1; z <= new_version_parts[2]; z++ )); do
        next_version="${current_version_parts[0]}.${current_version_parts[1]}.$z"
        commit_message="${commit_message}* https://cdn.kernel.org/pub/linux/kernel/v${current_version_parts[0]}.x/ChangeLog-${next_version}"$'\n'
    done

    # remove trailing newline
    commit_message=$(echo -n "$commit_message")
fi

git commit -m "$commit_message" "${defconfigs[@]}" Documentation/kernel.md

./scripts/check-kernel-patches.sh
