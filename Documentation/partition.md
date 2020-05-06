# Partition

The partition layout is a bit different on the first part. We prefere GPT every time where is possible. With SoCs they don't support GPT, we can use the hyprid GPT. More about this on [development](development.mnd) documentation.

The system is designed to have less as possible writes on the system. Which means we have basicly just writes on the OTA update and pretty small (5-6 times per week) on the overlay part. The Data partition have real I/O which is possible to offload into a different drive.

Basic it look like:

```
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

The data partation is the only partition with real I/O. It will be expanded automatic on boot time to the full size of the disk. 

This partition can be offloaded to a different drive with the utility:
```sh
$ datactl move /dev/xxx
```

On next boot, the partition will be moved to the new drive. The drive need to be bigger as the old one and we own the full new drive.
