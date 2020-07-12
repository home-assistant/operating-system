# Intel NUC

## Supported Hardware

This board configuration supports the Intel NUC mini PCs and compatibles. Most recent MUC computers will probably work.

## Tested Hardware

| Device                | Release Date  | Support |
|-----------------------|---------------|---------|
| Intel NUC5CPYH        | Q3 2015       | yes     |
| Intel NUC6CAYH        | Q4 2016       | yes     |
| Intel NUC10i3FNK2     | Q4 2019       | yes     |
| Gigabyte GB-BPCE-3455 | 2017          | yes*    |

\* needs 'nomodeset' in cmdline.txt if you want a console

Config is `intel_nuc` for all these devices.

## Requirements
- x86-64 support
- UEFI boot
- SATA/AHCI storage
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

Bluetooth is untested.

## Installation

Currently there is no shiny installation method. Checklist:
- Boot PC to live-environment using PXE or USB
- Copy or download the hassos image into your live environment
- zcat the image to local harddisk
- Reboot
