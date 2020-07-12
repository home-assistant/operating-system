# Intel NUC

This board configuration supports the Intel NUC mini PCs and compatibles. 
Probably most recent computers will work.

Requirements:
- x86-64 support
- UEFI boot
- SATA/AHCI storage
- Supported NIC:
  - Intel Gigabit NIC (e1000, igb - via Linux mainline)
  - Intel PCIe Gigabit NIC (e1000e - via out-of-tree module in *buildroot-external/package/intel-e1000e*)
  - Realtek Gigabit NIC (r8169)
  - Intel Wireless Wifi 802.11ac (iwlwifi, see below)

## Tested Hardware

| Device | Quirks | 
|--------|-----------|
| Intel NUC5CPYH |  |
| Intel NUC6CAYH |  |
| Intel NUC10I3FNK2 |  |
| Gigabyte GB-BPCE-3455 | needs 'nomodeset' in cmdline.txt if you want a console |


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

