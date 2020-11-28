Marvell ESPRESSObin
===================

This default configuration allows you to quickly get up and running with
the Marvell ESPRESSObin board by Globalscale Technologies Inc.

The ESPRESSObin is based on the Marvell Armada 88F3720 SoC, coupled with
a Marvell 88E6341 switch core "Topaz", with three exposed gigabit ports.

     _________________________
    |#  U     W   L  L    U  #|
    |#  S     A   A  A    S  #|
    |#  B     N   N  N    B  #|
    |#            0  1       #|
    |#      Mini             #|
    |#      -PCI             #|
    |#                       #|
    |#  5                    #|
    |#__V___usb_PWR_SATA__SW_#|

    Fig 1: Overview of board

Notice difference in Ethernet port layout compared to the Globalscale
docs.  They order the ports; LAN2, LAN1, WAN (left to right in figure
above).  For more information, see http://espressobin.net


Building
--------

    $ make globalscale_espressobin_defconfig
    $ make

This generates the kernel image, the devicetree binary, the rootfs as a
tar.gz, and a filesystem image containing everything.

All build artifacts are located in `output/images/`


Booting
-------

To boot, you need a UART connection, using the on-board micro USB port
set to 115200 8N1.

By default, the ESPRESSObin comes with a pre-flashed U-Boot set up to
load the kernel, device-tree and rootfs from SPI NOR flash.  The board
jumpers can be changed to boot from different sources, see the quick
start guide for each board revision for details:

- ftp://downloads.globalscaletechnologies.com/Downloads/Espressobin/ESPRESSObin%20V5/
- ftp://downloads.globalscaletechnologies.com/Downloads/Espressobin/ESPRESSObin%20V7/

Note: the v5, and earlier, cannot boot from sdcard, so you have to set
up the factory U-Boot to boot into Buildroot:

1. Flash rootfs image to sdcard drive, your `of=` device may differ:

        $ sudo dd if=output/images/sdcard.img of=/dev/mmcblk0 bs=1M
        $ sync

2. Boot board from SPI NOR, interrupt boot by pressing any key ...
3. Check with `printenv` that the default setup is OK, otherwise ensure
   the following are set, and define `bootcmd` for automatic boot:

        > setenv kernel_addr 0x5000000
        > setenv fdt_addr 0x1800000
        > setenv fdt_name boot/armada-3720-espressobin.dtb
        > setenv console console=ttyMV0,115200 earlycon=ar3700_uart,0xd0012000
        > setenv bootcmd 'mmc dev 0; ext4load mmc 0:1 $kernel_addr $image_name;ext4load mmc 0:1 $fdt_addr $fdt_name;setenv bootargs $console root=/dev/mmcblk0p1 rw rootwait; booti $kernel_addr - $fdt_addr'

4. Call the boot command, or `reset` the board to start:

        > run bootcmd


Networking
----------

To enable Ethernet networking, load the `mv88e6xxx` kernel module, and
bring up each respective interface needed:

    # modprobe mv88e6xxx
    # ifconfig wan up

A more advanced scenario is setting up switching between the ports using
the Linux bridge.  The kernel switchdev layer, and DSA driver, ensure
switch functions are "offloaded" to the HW switch, i.e., all traffic
between LAN ports never reach the CPU.  For this you need the iproute2
suite of tools.
