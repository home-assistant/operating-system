# ODROID-XU4

## eMMC

The ODROID XU4 uses the eMMC boot partition to boot from. Typically eMMC readers can't write to this eMMC boot partition. There are a couple of possibilities:

1. **Working** e.g. the eMMC already had a working image before flashing HassOS:
   - It will be booting to U-Boot (but no further).
     - If you have the serial adapter, you should be able to enter `distro_bootcmd` at the uboot prompt to continue booting.
     - If not, flash the HassOS image to an SD card and boot off that temporarily (while the eMMC is also plugged in).
   - Once booted, login at the prompts and then enter `dd if=/dev/mmcblk0 of=/dev/mmcblk0boot0 bs=512 skip=63 seek=62 count=1440` at the linux prompt.
   - Reboot with eMMC (don't forget to flip the boot switch to eMMC)
2. **Not Working** e.g. a clean/wiped/corruped eMMC boot partition:
   - You'll need to follow [Hardkernel's instructions](https://forum.odroid.com/viewtopic.php?f=53&t=6173) to get a working boot sector. Then flash HassOS and follow instructions above.
   - Alternatively, you can try flash HassOS to both an SD and eMMC, then boot off the SD with the eMMC also plugged in, then run `dd if=/dev/mmcblk1 of=/dev/mmcblk0boot0 bs=512 skip=1 seek=0 count=16381` at the Linux prompt. Note that this is untested, but in theory should work..

If you are getting permissions issues when using the dd command, try disabling RO:
`echo 0 > /sys/block/mmcblk0boot0/force_ro`
to re-enable after running dd:
`echo 1 > /sys/block/mmcblk0boot0/force_ro`

## Console

By default, console access is granted over the serial header and over HDMI. Certain startup messages will only appear on the serial console by default. To show the messages on the HDMI console instead, swap the order of the two consoles in the `cmdline.txt` file on the boot partition. You can also delete the SAC2 console if you don't plan on using the serial adapter.
eg. `console=tty1 console=ttySAC2,115200`

## GPIO

Refer to [the odroid wiki](https://wiki.odroid.com/odroid-xu4/hardware/expansion_connectors).
