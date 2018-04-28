# WORK IN PROGRESS!

# Hass.io OS
Hass.io OS based on [buildroot](https://buildroot.org/). It's a hypervisor for Docker and supports various kind of IoT hardware. It is also available as virtual appliance. The whole system is optimized for embedded system and  security. You can update the system simple with OTA updates or offline updates.

## Focus

- Linux kernel 4.15
- Barebox as bootloader
- RAUC for OTA updates
- SquashFS LZ4 as filesystem
- Docker 17.12.1
- ZRAM LZ4 for /tmp, /var, swap
- Run every supervisor

## Schemas
![](misc/hassio-os-partition.png?raw=true)

## Configuration

Create a USB stick with a partition named "hassio-config". This partition can include follow files:

- network-* (NetworkManager keyfiles)
- known_hosts (SSH)
- hassio-os-*.ota (Firmware updates)

# Customize

## Supervisor/Cli

Provide a file with the name `hassio.json` in your data partition and the following structure:

```json
{
  "supervisor": "repo/image",
  "supervisor_args": "optional / custom docker arguments",
  "cli": "repo/image",
  "cli_args": "optional / custom docker arguments"
}
```

# Building
Running `sudo ./enter.sh` will get you into the build Docker container.   
`make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external xy_defconfig`

From outside the Docker container, while it is still running you can use `./getimage.sh` to get the output image.

## Helpers

- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external defconfig BR2_DEFCONFIG=/build/buildroot-external/configs/xy_defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external menuconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external linux-menuconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external barebox-menuconfig`

- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external savedefconfig BR2_DEFCONFIG=/build/buildroot-external/configs/xy_defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external linux-update-defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external barebox-update-defconfig`
