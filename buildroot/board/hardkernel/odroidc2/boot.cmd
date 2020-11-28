setenv kernel_filename "Image"
setenv fdt_filename "meson-gxbb-odroidc2.dtb"
setenv bootargs "console=ttyAML0,115200n8 earlyprintk root=/dev/mmcblk1p2 rootwait rw"

echo > Loading Kernel...
fatload mmc 0:1 ${kernel_addr_r} ${kernel_filename}
echo > Loading FDT...
fatload mmc 0:1 ${fdt_addr_r} ${fdt_filename}

echo > Booting System...
booti ${kernel_addr_r} - ${fdt_addr_r}
