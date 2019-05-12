[![Build Status](https://dev.azure.com/home-assistant/Hass.io/_apis/build/status/hassos?branchName=dev)](https://dev.azure.com/home-assistant/Hass.io/_build/latest?definitionId=13&branchName=dev)

# HassOS
Hass.io OS based on [buildroot](https://buildroot.org/). It's a hypervisor for Docker and supports various kind of IoT hardware. It is also available as virtual appliance. The whole system is optimized for embedded system and  security. You can update the system simple with OTA updates or offline updates.

## Focus

- Barebox as bootloader on EFI
- U-Boot as bootloader on IoT
- RAUC for OTA updates
- SquashFS LZ4 as filesystem
- Docker 18.09.0
- AppArmor protected
- ZRAM LZ4 for /tmp, /var, swap
- Run every supervisor
