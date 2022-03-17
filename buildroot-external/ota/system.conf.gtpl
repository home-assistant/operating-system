[system]
compatible={{ env "ota_compatible" }}
mountprefix=/run/rauc
statusfile=/mnt/data/rauc.db
bootloader={{ env "BOOTLOADER" }}
{{- if eq (env "BOOTLOADER") "grub" }}
{{- if eq (env "BOOT_SYS") "efi" }}
grubenv=/mnt/boot/EFI/BOOT/grubenv
{{- else }}
grubenv=/mnt/boot/grubenv
{{- end }}
{{- end }}

[keyring]
path=/etc/rauc/keyring.pem

[slot.boot.0]
device=/dev/disk/by-partlabel/hassos-boot
type=vfat
allow-mounted=true
{{- if eq (env "BOOT_SPL") "true" }}
[slot.spl.0]
device=/dev/disk/by-partlabel/hassos-boot
type=raw
{{- end }}

[slot.kernel.0]
device=/dev/disk/by-partlabel/hassos-kernel0
type=raw
bootname=A

[slot.rootfs.0]
device=/dev/disk/by-partlabel/hassos-system0
type=raw
parent=kernel.0

[slot.kernel.1]
device=/dev/disk/by-partlabel/hassos-kernel1
type=raw
bootname=B

[slot.rootfs.1]
device=/dev/disk/by-partlabel/hassos-system1
type=raw
parent=kernel.1
