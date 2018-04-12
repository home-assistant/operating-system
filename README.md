# WORK IN PROGRESS!

# Hass.io OS
Hass.io OS based on buildroot. It's a hypervisor for docker and support many kind of IoT hardware. It is also available as Virtual Appliance. It's optimazed for embedded system and high security. You can update the system simple with OTA updates or offline Updates.

## Focus
- Linux kernel 4.15
- Barebox as bootloader
- RAUC for OTA updates
- SquashFS LZ4 for filesystem
- Docker 17.12.1
- ZRAM LZ4 for /tmp, /var, swap
- Run every supervisor

## Schemas
![](misc/hassio-os-partition.png?raw=true)

## Config
Create a USB stick with a partition "hassio-config". This partition can include follow files:

- network-* (NetworkManager keyfiles)
- known_hosts (SSH)
- hassio-os-*.ota (Firmware updates)

# Customize

## Supervisor/Cli

Provide a `supervisor.json` on your data partition they can/need follow struct:
```json
{
  "supervisor": "repo/image",
  "data_folder": "name_of_data_folder",
  "supervisor_args": "optional / custom docker arguments",
  "cli": "repo/image",
  "cli_args": "optional / custom docker arguments"
}
```

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
