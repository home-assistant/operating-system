# Partition

The partition layout is a bit different than the typical setup. We prefer GPT, if possible. With SoCs which don't support GPT, we use a hybrid GPT. For more details about this topic, please refer to the [development](development.md) documentation.

The system is designed to have as few write operations to the storage media as possible. This means that we only write during the OTA updates and 5-6 times per week on the overlay partition. The data partition receives the main I/O operations and for this reason is ideal for placing on a different drive.

A visual representation looks like this:

```text
-------------------------
|       Bootloader      |
-------------------------
|       Kernel A        |
-------------------------
|       System A        |
|                       |
-------------------------
|       Kernel B        |
-------------------------
|       System B        |
|                       |
-------------------------
|       Bootstate       |
-------------------------
|       Overlay         |
|                       |
...

-------------------------
|       Data            |
|                       |
-------------------------
```

Sometime the bootloader part can look different because there can be firmware or SPLs for boot the CPU on the SoC.

## Data

The data partition is the only partition with real I/O. It will be expanded automatically at boot to the full size of the disk.


## Using datactl to move the data partition.

In a Home Assistant OS installation, the data is stored on the `/mnt/data` partition of the SD card. This is the only read+write partition on the SD drive. Using the `datactl` move command, this partition can be moved off of the SD card onto an externally connected drive, leaving the rest of the read-only system on the SD.

The storage capacity of the external drive must be larger than the storage capacity of the existing SD card.

The command needs to be run from the host console by either connecting a keyboard and monitor or making use of the [debug ssh access](https://developers.home-assistant.io/docs/operating-system/debugging/) over port 22222. The command will not work from within an SSH add-on container.

Log in as `root` to get to the Home Assistant CLI and then enter `login` to continue to the host.

Confirm your USB SSD/HD is connected and recognized using `fdisk -l`.

Make sure the drive has no partition named `hassos-data` (or no partition at all). With the drive, use the below command (again, replacing XXX with your drive)

```sh
$ datactl move /dev/xxx
```

Hit any key to continue, and then the move will happen after the next reboot. Once complete, the external drive will be owned and used by the system.
