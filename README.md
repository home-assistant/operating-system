# Home Assistant Operating System

Home Assistant Operating System (formerly HassOS) is an operating system optimized for hosting [Home Assistant](https://www.home-assistant.io) and its [Add-ons](https://www.home-assistant.io/addons/).

Home Assistant Operating System uses Docker as Container engine. It by default deploys the Home Assistant Supervisor as a container. Home Assistant Supervisor in turn uses the Docker container engine to control Home Assistant Core and Add-Ons in separate containers. Home Assistant Operating System is **not** based on a regular Linux distribution like Ubuntu. It is built using [buildroot](https://buildroot.org/) and it is optimized for running Home Assistant, especially on single board compute (SBC) devices like the Pi, ODROID, NUC and Tinker Board (see supported hardware below).

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

See the full list and specific models [here](./Documentation/boards/README.md)

## Getting Started

If you just want to use Home Assistant the official [getting started guide](https://www.home-assistant.io/getting-started/) and [installation instructions](https://www.home-assistant.io/hassio/installation/) take you through how to download Home Assistant Operating System and get it running on your machine.

If you're interested in finding out more about Home Assistant Operating System and how it works read on...

## HassOS components

- **Bootloader:**
  - [Barebox](https://barebox.org/) for devices that support EFI
  - [U-Boot](https://www.denx.de/wiki/U-Boot) for devices that don't support EFI
- **Operating System:**
  - [Buildroot](https://buildroot.org/) LTS Linux
- **File Systems:**
  - [SquashFS](https://www.kernel.org/doc/Documentation/filesystems/squashfs.txt) for read-only file systems (using LZ4 compression)
  - [ZRAM](https://www.kernel.org/doc/Documentation/blockdev/zram.txt) for `/tmp`, `/var` and swap (using LZ4 compression)
- **Container Platform:**
  - [Docker Engine](https://docs.docker.com/engine/) for running Home Assistant components in containers
- **Updates:**
  - [RAUC](https://rauc.io/) for Over The Air (OTA) and USB updates
- **Security:**
  - [AppArmor](https://apparmor.net/) Linux kernel security module

If you don't have experience with these, embedded systems, buildroot or the build process for Linux distributions, then please read up on these topics. The rest of the documentation in this project is for developers and assumes you have experience with embedded systems or a strong understanding of the internal workings of operating systems.

## Developer Documentation

All developer documentation is in the [Documentation](./Documentation) directory.

### Development builds

The Development build GitHub Action Workflow is a manually triggered workflow
which creates Home Assistant OS development builds. The development builds are
available at [os-builds.home-assistant.io](https://os-builds.home-assistant.io/).
