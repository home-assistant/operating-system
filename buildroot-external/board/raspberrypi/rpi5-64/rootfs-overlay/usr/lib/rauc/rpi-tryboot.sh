#!/bin/sh

# shellcheck source=/dev/null # Our GitHub Actions tests this separately
. /usr/lib/rauc/cmdline.sh

# RAUC hook script for Raspberry Pi firmwaree tryboot
# Meant to be usesd as a RAUC bootloader-custom-backend script.

boot_dir="/mnt/boot"
root_slot_a="PARTUUID=8d3d53e3-6d49-4c38-8349-aff6859e82fd"
root_slot_b="PARTUUID=a3ec664e-32ce-4665-95ea-7ae90ce9aa20"

case "$1" in
    get-primary)
        # Actions to be performed when getting the primary bootloader
        # Example: Output the path to the current primary bootloader
        echo "tryboot get-primary" >&2
        cmdline=$(head -n1 "${boot_dir}/cmdline.txt")
        get_value rauc.slot "${cmdline}"
        ;;

    set-primary)
        # Actions to be performed when setting the primary bootloader
        # Example: Set the specified bootloader as the primary one
        slot_bootname="$2"
        echo "tryboot set-primary $slot_bootname" >&2
        cmdline=$(head -n1 "${boot_dir}/cmdline.txt")
        if [ "${slot_bootname}" = "A" ]; then
            cmdline=$(set_value root "${root_slot_a}" "${cmdline}")
        elif [ "${slot_bootname}" = "B" ]; then
            cmdline=$(set_value root "${root_slot_b}" "${cmdline}")
        else
            exit 1
        fi
        cmdline=$(set_value rauc.slot "${slot_bootname}" "${cmdline}")
        echo "${cmdline}" > "${boot_dir}/cmdline-tryboot.txt"
        sed -e "s/^\(os_prefix=\)slot-[A-Z]\/$/\1slot-${slot_bootname}\//" \
            -e "s/^\(cmdline=\).*$/\1\/cmdline-tryboot.txt/" \
            "${boot_dir}/config.txt" > "${boot_dir}/tryboot.txt"
        # Use tryboot to try booting the new primary on reboot
        echo "0 tryboot" > /run/systemd/reboot-param
        ;;

    get-state)
        # Actions to be performed when getting the bootloader state
        # Example: Output the current state of the bootloader
        # You need to implement logic to determine the state (good or bad) based on the slot.bootname
        slot_bootname="$2"
        echo "tryboot get-state $slot_bootname" >&2
        if [ -f "${boot_dir}/slot-${slot_bootname}/.good" ]; then
            echo "returning good" >&2
            echo "good"
        else
            echo "returning bad" >&2
            echo "bad"
        fi
        ;;

    set-state)
        # Actions to be performed when setting the bootloader state
        # Example: Set the specified state for the bootloader
        slot_bootname="$2"
        new_state="$3"
        echo "tryboot set-state $slot_bootname $new_state" >&2
        if [ "${new_state}" = "good" ]; then
            touch "${boot_dir}/slot-${slot_bootname}/.good"
        else
            rm -f "${boot_dir}/slot-${slot_bootname}/.good"
            exit 0
        fi

        # It seems we call set-state in any case. Use this to "commit" tryboot
        # state...

        # Check if tryboot is active
        if ! cmp -s -n 4 /proc/device-tree/chosen/bootloader/tryboot /dev/zero; then
            cmdline_tryboot=$(head -n1 "${boot_dir}/cmdline-tryboot.txt")
            tryboot_slot=$(get_value rauc.slot "${cmdline_tryboot}")
            if [ "${tryboot_slot}" != "${slot_bootname}" ]; then
                echo "tryboot doesn't reflect the expected boot slot, not committing." >&2
                exit 1
            fi
            echo "Committing tryboot state to primary boot" >&2
            sed -e "s/^\(cmdline=\).*$/\1\/cmdline.txt/" \
                "${boot_dir}/tryboot.txt" > "${boot_dir}/config.txt"
            mv "${boot_dir}/cmdline-tryboot.txt" "${boot_dir}/cmdline.txt"
            rm "${boot_dir}/tryboot.txt"
        fi
        ;;

    get-current)
        # We don't have a better detection then /proc/cmdline...
        echo "Cannot reliably determine current slot with tryboot" >&2
        exit 1
        ;;

    *)
        echo "Unknown operation: $1"
        exit 1
        ;;
esac

exit 0
