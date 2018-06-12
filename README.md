# HassOS
Hass.io OS based on [buildroot](https://buildroot.org/). It's a hypervisor for Docker and supports various kind of IoT hardware. It is also available as virtual appliance. The whole system is optimized for embedded system and  security. You can update the system simple with OTA updates or offline updates.

## Focus

- Linux kernel 4.14 (LT)
- Barebox as bootloader on EFI
- U-Boot as bootloader on IoT
- RAUC for OTA updates
- SquashFS LZ4 as filesystem
- Docker 18.03.1
- AppArmor protected
- ZRAM LZ4 for /tmp, /var, swap
- Run every supervisor

# Building
Running `sudo ./enter.sh` will get you into the build Docker container.   
`make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external xy_defconfig`

## Helpers

- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external xy_defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external menuconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external linux-menuconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external barebox-menuconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external busybox-menuconfig`

- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external savedefconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external linux-update-defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external barebox-update-defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external busybox-update-config`
