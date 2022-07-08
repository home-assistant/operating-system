# Generic x86-64

## Supported Hardware

This board configuration aims to support most x86-64 systems with UEFI boot. The
main aim is to support Intel NUC mini PCs and similar systems. Hardware it has
been tested with is listed below.

## Tested Hardware

| Device                | Release Date | Support | Config      |
|-----------------------|--------------|---------|-------------|
| Intel NUC5CPYH        | Q3 2015      | yes     | [generic_x86_64](../../../buildroot-external/configs/generic_x86_64_defconfig) |
| Intel NUC6CAYH        | Q4 2016      | yes     | [generic_x86_64](../../../buildroot-external/configs/generic_x86_64_defconfig) |
| Intel NUC6CAYS        | Q4 2016      | yes     | [generic_x86_64](../../../buildroot-external/configs/generic_x86_64_defconfig) |
| Intel NUC7i3DNHE	| Q3 2017      | yes     | [generic_x86_64](../../../buildroot-external/configs/generic_x86_64_defconfig) |
| Intel NUC10i3FNK2     | Q4 2019      | yes     | [generic_x86_64](../../../buildroot-external/configs/generic_x86_64_defconfig) |
| Gigabyte GB-BPCE-3455 | 2017         | yes*    | [generic_x86_64](../../../buildroot-external/configs/generic_x86_64_defconfig) |

\* needs 'nomodeset' in cmdline.txt if you want a console


## Requirements

- x86-64 support
- UEFI boot
- SATA/AHCI or eMMC storage
- Supported NIC:
  - Intel Gigabit NIC (e1000, igb - via Linux mainline)
  - Intel PCIe Gigabit NIC (e1000e - via out-of-tree module in *buildroot-external/package/intel-e1000e*)
  - Realtek Gigabit NIC (r8169)
  - Intel Wireless Wifi 802.11ac (iwlwifi, see below)

## Wifi

The following cards are supported:

- Intel Wireless 3160
- Intel Wireless 7260
- Intel Wireless 7265
- Intel Wireless-AC 3165
- Intel Wireless-AC 3168
- Intel Wireless-AC 8260
- Intel Wireless-AC 8265
- Intel Wireless-AC 9260
- Intel Wireless-AC 9461
- Intel Wireless-AC 9462
- Intel Wireless-AC 9560

## Bluetooth

Bluetooth integrated in Intel Wireless cards working OK, other options untested.

## Installation

Make sure secure boot is disabled in the UEFI BIOS settings.

Currently there is no shiny installation method. Checklist:
- Boot PC to live environment using PXE or USB
- Copy or download the Home Assistant OS image into your live environment
- unxz the image and dd to the local hard disk
- Reboot
