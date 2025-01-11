[update]
compatible={{ env "ota_compatible" }}
version={{ env "ota_version" }}

[bundle]
format=verity

[hooks]
filename=hook
hooks=install-check;

[image.boot]
filename=boot.vfat
hooks=install;

[image.kernel]
filename=kernel.img
{{- if eq (env "BOOTLOADER") "tryboot" }}
hooks=post-install;
{{- end }}

[image.rootfs]
filename=rootfs.img

{{- if eq (env "BOOT_SPL") "true" }}
[image.spl]
filename=spl.img
hooks=install
{{- end }}
