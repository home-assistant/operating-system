This is the support for the ARM Foundation v8 machine emulated by the
ARM software simulator of the AArch64 architecture.

First, one has to download the AArch64 software simulator from:

  https://silver.arm.com/download/download.tm?pv=4807186

Then, use the arm_foundationv8_defconfig configuration to build your
Buildroot system.

Finally, boot your system with:

 ${LOCATION_OF_FOUNDATIONV8_SIMULATOR}/models/Linux64_GCC-6.4/Foundation_Platform \
    --image output/images/linux-system.axf \
    --block-device output/images/rootfs.ext2 \
    --network=nat \
    --cores 4

You can get network access from within the simulated environment
by requesting an IP address using DHCP (run the command 'udhcpc').
