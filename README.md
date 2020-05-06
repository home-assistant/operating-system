[![Build Status](https://dev.azure.com/home-assistant/Hass.io/_apis/build/status/hassos?branchName=dev)](https://dev.azure.com/home-assistant/Hass.io/_build/latest?definitionId=13&branchName=dev)

# Home Assistant Operating-System
Hass.io OS based on [buildroot](https://buildroot.org/). It's a hypervisor for Docker and supports various kind of IoT hardware. It is also available as virtual appliance. The whole system is optimized for embedded system and  security. You can update the system simple with OTA updates or offline updates.

This is a embedded Linux which work different as a normal Linux distribution. The system is designed to run which less as possible I/O and full optimized for what is needed to be. Not more and not less. If you don't have expirence with embedded systems, that will be the point to go out of this repository. All docs are for developer with embedded background.

## Focus

- Barebox as bootloader on EFI
- U-Boot as bootloader on IoT
- Linux/Buildroot LTS
- RAUC for OTA updates
- SquashFS LZ4 as filesystem
- Docker-CE
- AppArmor protected
- ZRAM LZ4 for /tmp, /var, swap
