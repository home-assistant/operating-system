# Home Assistant Operating System

Home Assistant Operating System (HassOS) is an operating system optimized for hosting [Home Assistant](https://www.home-assistant.io) and its [Add-ons](https://www.home-assistant.io/addons/).

HassOS is uses Linux as a hypervisor for Docker, allowing each component of Home Assistant including add-ons to run in separate docker containers. It uses embedded Linux based on [buildroot](https://buildroot.org/), which is different to a "normal" Linux, and it is optimized for running Home Assistant on IoT devices.

## Features

- Lightweight and memory-efficient
- Minimized I/O
- Over The Air (OTA) updates
- Offline updates
- Modular using Docker

## Supported hardware

- Raspberry Pi
- Hardkernel ODROID
- Intel NUC
- Asus Tinker Board
- Virtual appliances

See full list and specific models [here]

## Getting Started

If you just want to use Home Assistant the official [getting started guide](https://www.home-assistant.io/getting-started/) and [installation instructions](https://www.home-assistant.io/hassio/installation/) take you through how to download HassOS and get it running on your machine.

If you're interested in finding out more about HassOS and how it works read on...

## HassOS components


* **Bootloader:**
  * [Barebox](https://barebox.org/) for devices that support EFI
  * [U-Boot](https://www.denx.de/wiki/U-Boot) for devices that don't support EFI
* **Operating System:**
  * [Buildroot](https://buildroot.org/) LTS Linux
* **File Systems:**
  * [SquashFS](https://www.kernel.org/doc/Documentation/filesystems/squashfs.txt) for read-only file systems (using LZ4 compression)
  * [ZRAM](https://www.kernel.org/doc/Documentation/blockdev/zram.txt) for `/tmp`, `/var` and swap (using LZ4 compression)
* **Container Platform:**
  * [Docker Engine](https://docs.docker.com/engine/) for running Home Assistant components in containers
* **Updates:**
  * [RAUC](https://rauc.io/) for Over The Air (OTA) and USB updates
* **Security:**
  * [AppArmor](https://apparmor.net/) Linux kernel security module

If you don't have experience with these, embedded systems, buildroot or the build process for Linux distributions, then please read up on these topics. The rest of the documentation in this project is for developers and assumes you have experience of embedded systems or a strong understanding of the internal workings of operating systems.

## Developer Documentation



* [Getting started](./Documentation/getting_started_development.md) - the place for developers to begin
* [Development](./Documentation/getting_started_development.md) - more deatils for developers
* [Deployment](./Documentation/deployment.md) - approach to git branching and releases
* [Configuration](./Documentation/configuration.md) - how users can configure HassOS
* [Partition](./Documentation/partition.md) - partition layout
* [Network](./Documentation/network.md) - approach to networking
* [Bluetooth](./Documentation/bluetooth.md) - approach to bluetooth
* [Kernel](./Documentation/kernel.md) - kernel versions



(This documentation is kept in the [Documentation](./Documentation) directory.)
