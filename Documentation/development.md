# Development

## Boot system

`BOOT_SYS`:
- efi
- hyprid
- spl
- mbr

HassOS is basicly used GPT. But for use GPT we need own the first 1024 of
boot drive. Is that not possible, you can use MBR for your device, they work also with SPLs.

Hyprid and SPL use both a hyprid MBR/GPT table but SPL move the GPT header 8MB for give space to write SPL and boot images before.

`BOOTLOADER`:
- uboot
- barebox

We support mainly uboot but for uefi system we can also use barebox. In future we hope to remove barebox with uboot also on uefi.

`DISK_SIZE`:
Default 2. That is the size of end image in GB.

