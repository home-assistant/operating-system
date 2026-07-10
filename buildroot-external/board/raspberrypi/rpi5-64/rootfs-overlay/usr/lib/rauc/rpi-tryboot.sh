#!/bin/sh

# shellcheck source=/dev/null # Our GitHub Actions tests this separately
. /usr/lib/rauc/cmdline.sh

# RAUC hook script for Raspberry Pi firmware tryboot
# Meant to be used as a RAUC bootloader-custom-backend script.

boot_dir="/mnt/boot"
root_slot_a="PARTUUID=8d3d53e3-6d49-4c38-8349-aff6859e82fd"
root_slot_b="PARTUUID=a3ec664e-32ce-4665-95ea-7ae90ce9aa20"
reboot_param="/run/systemd/reboot-param"

# Slot the firmware boots by default (committed state)
committed_slot() {
    cmdline=$(head -n1 "${boot_dir}/cmdline.txt")
    get_value rauc.slot "${cmdline}"
}

# Slot staged for tryboot, empty if no tryboot is staged
staged_slot() {
    if [ -f "${boot_dir}/cmdline-tryboot.txt" ]; then
        cmdline_tryboot=$(head -n1 "${boot_dir}/cmdline-tryboot.txt")
        get_value rauc.slot "${cmdline_tryboot}"
    fi
}

# Whether the next reboot is armed to use the firmware tryboot mechanism
tryboot_armed() {
    [ -f "${reboot_param}" ] && grep -q "tryboot" "${reboot_param}"
}

# Drop a staged tryboot including its armed reboot parameter
clear_staged() {
    rm -f "${boot_dir}/cmdline-tryboot.txt" "${boot_dir}/tryboot.txt"
    if tryboot_armed; then
        rm -f "${reboot_param}"
    fi
}

get_primary() {
    echo "tryboot get-primary" >&2
    staged=$(staged_slot)
    if [ -n "${staged}" ] && tryboot_armed; then
        # An installed update stays primary until its tryboot reboot happened
        echo "${staged}"
    else
        committed_slot
    fi
}

# Called when the booted slot is marked good after a regular (non-tryboot)
# boot. The firmware attempts a staged tryboot exactly once: if a tryboot is
# still staged but no tryboot reboot is armed anymore, the previous boot
# either lost the armed reboot parameter (power cut before the activation
# reboot, /run is volatile) or the tryboot attempt failed and the firmware
# fell back to the default slot. Either way the staged slot missed its one
# attempt: drop it and mark it bad, a new install stages it again.
drop_stale_tryboot() {
    staged=$(staged_slot)

    if [ -z "${staged}" ] || tryboot_armed; then
        # Nothing staged, or staged during this boot with the activation
        # reboot still pending
        return
    fi

    echo "Dropping staged tryboot to slot ${staged}, marking it bad" >&2
    rm -f "${boot_dir}/slot-${staged}/.good"
    clear_staged
}

case "$1" in
    get-primary)
        get_primary
        ;;

    set-primary)
        slot_bootname="$2"

        if [ "${slot_bootname}" = "$(committed_slot)" ]; then
            # The requested slot is the default boot slot already. Cancel a
            # staged tryboot if there is one (e.g. an installed update that
            # still awaits its activation reboot).
            if [ -n "$(staged_slot)" ]; then
                echo "tryboot set-primary $slot_bootname: cancelling staged tryboot to $(staged_slot)" >&2
                clear_staged
            else
                echo "tryboot set-primary $slot_bootname: already set" >&2
            fi
            exit 0
        fi

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
        echo "0 tryboot" > "${reboot_param}"
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

        if [ "${new_state}" != "good" ]; then
            # Marking the staged slot bad cancels its pending tryboot
            if [ "$(staged_slot)" = "${slot_bootname}" ]; then
                clear_staged
            fi
            rm -f "${boot_dir}/slot-${slot_bootname}/.good"
            exit 0
        fi

        # It seems we call set-state in any case. Use this to "commit" tryboot
        # state...

        # Commit the tryboot state if we booted via tryboot and the booted
        # slot is not the default boot slot yet. The firmware's tryboot flag
        # stays set for the entire boot, so it alone can't tell whether the
        # commit already happened — a tryboot staged later in the same boot
        # (e.g. an update installed after the commit) must be left alone.
        if ! cmp -s -n 4 /proc/device-tree/chosen/bootloader/tryboot /dev/zero \
            && [ "$(committed_slot)" != "${slot_bootname}" ]; then
            if [ ! -f "${boot_dir}/cmdline-tryboot.txt" ]; then
                echo "cmdline-tryboot.txt not found, can't commit current state." >&2
                exit 1
            fi
            # tryboot.txt MUST exist at this point
            if [ ! -f "${boot_dir}/tryboot.txt" ]; then
                echo "tryboot.txt not found, can't commit current state." >&2
                exit 1
            fi
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
            rm -f "${reboot_param}"
        else
            drop_stale_tryboot
        fi

        # Only the "good" state reaches this point, all others exit early
        touch "${boot_dir}/slot-${slot_bootname}/.good"
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
