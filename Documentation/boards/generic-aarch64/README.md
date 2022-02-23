# Generic aarch64

## Supported Hardware

This board configuration aims to support most aarch64 systems with UEFI boot
Hardware it has been tested with is listed below.

## Tested Hardware

| Device                | Release Date | Support | Config      |
|-----------------------|--------------|---------|-------------|
| QEMU                  | QEMU         | yes     | [generic_aarch64](../../../buildroot-external/configs/generic_aarch64_defconfig) |


## Requirements

- aarch64 support
- UEFI boot

## Wifi

WiFi is untested.

## Bluetooth

Bluetooth is untested.

## Installation

Make sure secure boot is disabled in the UEFI BIOS settings.

Currently there is no shiny installation method. Checklist:
- Boot PC to live environment using PXE or USB
- Copy or download the Home Assistant OS image into your live environment
- unxz the image and dd to the local hard disk
- Reboot
