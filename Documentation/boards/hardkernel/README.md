# ODROID

## Supported Hardware

| Device         | Release Date  | Support      | Config    |
|----------------|---------------|--------------|-----------|
| ODROID-C2      | 2016          | yes          | [odroid_c2](../../../buildroot-external/configs/odroid_c2_defconfig) |
| ODROID-C4      | 2020          | yes          | [odroid_c4](../../../buildroot-external/configs/odroid_c4_defconfig) |
| ODROID-M1      | 2022          | yes          | [odroid_m1](../../../buildroot-external/configs/odroid_m1_defconfig) |
| ODROID-M1S     | 2023          | yes          | [odroid_m1s](../../../buildroot-external/configs/odroid_m1s_defconfig)|
| ODROID-N2      | 2019          | yes          | [odroid_n2](../../../buildroot-external/configs/odroid_n2_defconfig) |
| ODROID-XU4     | 2015          | yes          | [odroid_xu4](../../../buildroot-external/configs/odroid_xu4_defconfig)|

See separate documentation for each board.

## Connectivity devices

### Wi-Fi

The following devices have been tested on Home Assistant OS 5.8:

- [Bluetooth Module 2](https://www.hardkernel.com/shop/bluetooth-module-2/)
- [WiFi Module 3](https://www.hardkernel.com/shop/wifi-module-3/)

The [WiFi Module 5A](https://www.hardkernel.com/shop/wifi-module-5a/) is not
recommended as there is no upstream driver support available. The driver
currently compatible with recent Linux kernel version seems to have issues
connecting to 5GHz networks.
