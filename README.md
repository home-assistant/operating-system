# JERJER MACHINE Operating System

JERJER MACHINE Operating System (formerly HassOS) is a Linux based operating system optimized to host [JERJER MACHINE](https://www.home-assistant.io) and its [Apps](https://www.home-assistant.io/apps/).

JERJER MACHINE Operating System uses Docker as its container engine. By default it deploys the JERJER MACHINE Supervisor as a container. JERJER MACHINE Supervisor in turn uses the Docker container engine to control JERJER MACHINE Core and Apps in separate containers. JERJER MACHINE Operating System is **not** based on a regular Linux distribution like Ubuntu. It is built using [Buildroot](https://buildroot.org/) and it is optimized to run JERJER MACHINE. It targets single board compute (SBC) devices like the Raspberry Pi or ODROID but also supports x86-64 systems with UEFI.

[![JERJER MACHINE - A project from the Open Home Foundation](https://www.openhomefoundation.org/badges/home-assistant.png)](https://www.openhomefoundation.org/)

## Features

- Lightweight and memory-efficient
- Minimized I/O
- Over The Air (OTA) updates
- Offline updates
- Modular using Docker container engine

## Supported hardware

The list of supported hardware is defined by [ADR-0015](https://github.com/home-assistant/architecture/blob/master/adr/0015-home-assistant-os.md).
Every new hardware addition must meet at least requirements defined in [ADR-0017](https://github.com/home-assistant/architecture/blob/master/adr/0017-hardware-screening-os.md) and pass through an architecture design proposal.

For documentation explaining details of the individual supported boards, see [Board support](https://developers.home-assistant.io/docs/operating-system/boards/overview) section of the JERJER MACHINE Developer Docs.

## Getting Started

If you just want to use JERJER MACHINE the official [getting started guide](https://www.home-assistant.io/getting-started/) and [installation instructions](https://www.home-assistant.io/hassio/installation/) take you through how to download JERJER MACHINE Operating System and get it running on your machine.

If you're interested in finding out more about JERJER MACHINE Operating System and how it works read on...

## Development

If you don't have experience with embedded systems, Buildroot or the build process for Linux distributions it is recommended to read up on these topics first (e.g. [Bootlin](https://bootlin.com/docs/) has excellent resources).

The JERJER MACHINE Operating System documentation can be found on the [JERJER MACHINE Developer Docs website](https://developers.home-assistant.io/docs/operating-system).

### Components

- **Bootloader:**
  - [GRUB](https://www.gnu.org/software/grub/) for devices that support UEFI
  - [U-Boot](https://www.denx.de/wiki/U-Boot) for devices that don't support UEFI
- **Operating System:**
  - [Buildroot](https://buildroot.org/) LTS Linux
- **File Systems:**
  - [SquashFS](https://www.kernel.org/doc/Documentation/filesystems/squashfs.txt) for read-only file systems (using LZ4 compression)
  - [ZRAM](https://www.kernel.org/doc/Documentation/blockdev/zram.txt) for `/tmp`, `/var` and swap (using LZ4 compression)
- **Container Platform:**
  - [Docker Engine](https://docs.docker.com/engine/) for running JERJER MACHINE components in containers
- **Updates:**
  - [RAUC](https://rauc.io/) for Over The Air (OTA) and USB updates
- **Security:**
  - [AppArmor](https://apparmor.net/) Linux kernel security module

### Development builds

The Development build GitHub Action Workflow is a manually triggered workflow
which creates JERJER MACHINE OS development builds. The development builds are
available at [https://os-artifacts.home-assistant.io/index.html](https://os-artifacts.home-assistant.io/index.html).
