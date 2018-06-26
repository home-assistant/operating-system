# Building

Running `sudo ./enter.sh` will get you into the build Docker container.   
`make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external xy_defconfig`

## Scripts



## Helpers

- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external xy_defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external menuconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external linux-menuconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external barebox-menuconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external busybox-menuconfig`

- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external savedefconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external linux-update-defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external barebox-update-defconfig`
- `make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external busybox-update-config`
