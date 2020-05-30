# Partition

The partition layout is a bit different than for regular setups. We prefer GPT, if possible. With SoCs which don't support GPT, we use the hybrid GPT. For more details about this topic, please refer to the [development](development.md) documentation.

The system is designed to have as less as possible write operations on the storage media. Which means that we have basically only write during the OTA update and 5-6 times per week on the overlay part. The data partition is having I/O. This is the reason which is should be run on a different drive.

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

The data partition is the only partition with real I/O. It will be expanded automatic on boot time to the full size of the disk.

This partition can be offloaded to a different drive with the utility:

```sh
$ datactl move /dev/xxx
```

On next boot, the partition will be moved to the new drive. The drive needs to be bigger as the old one and we own the full new drive.
