# Home Assistant Operating system

Home Assistant Operating System (HassOS) is based on [buildroot](https://buildroot.org/). It's a hypervisor for Docker and supports various kind of hardware. It is also available as virtual appliance for different virtualization solutions. The whole system is optimized for hosting [Home Assistant](https://www.home-assistant.io) and its features (to be precise, the [Add-ons](https://www.home-assistant.io/addons/)). You can update the system by using OTA updates or offline updates.

This is an embedded Linux which works different than a normal Linux distribution. The system is designed to run with minimal I/O and is optimized for its tasks.

If you don't have experience with embedded systems, buildroot or the build process Linux distributions, then please read up on those topics. All provided documentation here is focusing on developers with a background on embedded systems or a strong understanding of the internal workings of operating systems.

## Focus

- Barebox as bootloader on EFI
- U-Boot as bootloader
- Linux/Buildroot LTS
- RAUC for OTA updates
- SquashFS LZ4 as filesystem
- Docker-CE
- AppArmor protected
- ZRAM LZ4 for `/tmp`, `/var` and swap
