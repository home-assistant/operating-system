setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p2 rootwait

mmc dev 0
fatload mmc 0 $kernel_addr_r zImage
fatload mmc 0 $fdt_addr_r sun8i-h2-plus-bananapi-m2-zero.dtb

bootz $kernel_addr_r - $fdt_addr_r
