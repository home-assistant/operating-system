# WORK IN PROGRESS!

# HassioOS
Hass.io OS based on buildroot

## Focus
- Linux kernel 4.15
- Barebox as bootloader
- RAUC for OTA updates
- SquashFS LZ4 for filesystem
- Docker 17.12.1
- ZRAM LZ4 for /tmp, /var, /run

## Schemas
![](misc/hassio-os-partition.png?raw=true)

## Config

Create a USB stick with a partition "hassio-config". This partition can include follow files:

- network-*.config
- swap.config

# Building
Running sudo `./enter.sh` will get you into the build docker container.   
`make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external xy_defconfig`

From outside the docker container, while it is still running you can use `./getimage.sh` to get the output image.

## Helpers

- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external defconfig BR2_DEFCONFIG=/build/buildroot-external/configs/xy_defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external menuconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external linux-menuconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external barebox-menuconfig`

- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external savedefconfig BR2_DEFCONFIG=/build/buildroot-external/configs/xy_defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external linux-update-defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external barebox-update-defconfig`
