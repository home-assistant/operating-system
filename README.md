## WORK IN PROGRESS!

# hassio-os
Hass.io OS based on buildroot

# building
Running sudo `./enter.sh` will get you into the build docker container.   
`make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external xy_defconfig`

From outside the docker container, while it is still running you can use `./getimage.sh` to get the output image.

# edit

`make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external defconfig BR2_DEFCONFIG=/build/buildroot-external/configs/xy_defconfig`
`make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external savedefconfig BR2_DEFCONFIG=/build/buildroot-external/configs/xy_defconfig`
