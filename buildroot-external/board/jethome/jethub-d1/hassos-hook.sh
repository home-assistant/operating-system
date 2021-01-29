#!/bin/bash
# shellcheck disable=SC2155

# Change size partitions
BOOT_SIZE=(64M 64M)
BOOTSTATE_SIZE=8M
SYSTEM_SIZE=256M
KERNEL_SIZE=64M
OVERLAY_SIZE=128M
DATA_SIZE=1G

set -e # Exit immediately if a command exits with a non-zero status
set -u # Treat unset variables and parameters as an error

# some functions
print_var() {
  if [ -n "$1" ] ; then
    echo "-- ${1}==${!1}"
  else
    echo "${FUNCNAME[0]}(): Null parameter passed to this function"
  fi
}

print_cmd_title() {
    if [ -n "$1" ] ; then
    echo "###### ${1} ######"
  else
    echo "${FUNCNAME[0]}(): Null parameter passed to this function"
  fi
}

self_name() {
  echo ${0##*/}
}


function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    echo "console=tty0 console=ttyAML0,115200n8" > "${BOOT_DATA}/cmdline.txt"
    cp "${BINARIES_DIR}/meson-axg-jethome-jethub-j100.dtb" "${BOOT_DATA}/meson-axg-jethome-jethub-j100.dtb"
}

function hassos_post_image() {
    convert_disk_image_xz
}

function create_disk_image() {
    _prepare_disk_image
    _create_disk_aml
}

function create_platform_conf () {
    echo 'Platform:0x0811' > ${BINARIES_DIR}/platform.conf
    echo 'DDRLoad:0xfffc0000' >> ${BINARIES_DIR}/platform.conf
    echo 'DDRRun:0xfffc0000' >> ${BINARIES_DIR}/platform.conf
    echo 'UbootLoad:0x200c000' >> ${BINARIES_DIR}/platform.conf
    echo 'UbootRun:0xfffc0000' >> ${BINARIES_DIR}/platform.conf
    echo 'Control0=0xfffc0000:0x000000b1' >> ${BINARIES_DIR}/platform.conf
    echo 'Control1=0xfffc0000:0x00005183' >> ${BINARIES_DIR}/platform.conf
    echo 'Encrypt_reg:0xff800228' >> ${BINARIES_DIR}/platform.conf
    echo 'bl2ParaAddr=0xfffcc000' >> ${BINARIES_DIR}/platform.conf
}

function _create_disk_aml() {
    local boot_img="$(path_boot_img)"
    local rootfs_img="$(path_rootfs_img)"
    local overlay_img="$(path_overlay_img)"
    local data_img="$(path_data_img)"
    local kernel_img="$(path_kernel_img)"
    local hdd_img="$(hassos_image_name img)"
    local hdd_count=${DISK_SIZE:-2}
    local disk_layout="${BINARIES_DIR}/disk.layout"
    local boot_start=$(size2sectors "8M")
    local bootloader_img="u-boot.bin" # bootloader
    local ubootbin_img="u-boot.bin.usb.tpl" # UBOOT
    local ddrbin_img="u-boot.bin.usb.bl2" # DDR

    echo '[LIST_NORMAL]' > ${BINARIES_DIR}/image.cfg
    echo 'file="'${ddrbin_img}'"		main_type="USB"		sub_type="DDR"'  >> ${BINARIES_DIR}/image.cfg
    echo 'file="'${ubootbin_img}'"		main_type="USB"		sub_type="UBOOT"' >> ${BINARIES_DIR}/image.cfg
    echo 'file="_aml_dtb.PARTITION"		main_type="dtb"		sub_type="meson1"' >> ${BINARIES_DIR}/image.cfg
    echo 'file="platform.conf"		main_type="conf"		sub_type="platform"' >> ${BINARIES_DIR}/image.cfg
    echo '' >> ${BINARIES_DIR}/image.cfg
    echo '[LIST_VERIFY]' >> ${BINARIES_DIR}/image.cfg
    echo 'file="_aml_dtb.PARTITION"	main_type="PARTITION"		sub_type="_aml_dtb"' >> ${BINARIES_DIR}/image.cfg
    echo 'file="'${bootloader_img}'"	main_type="PARTITION"		sub_type="bootloader"' >> ${BINARIES_DIR}/image.cfg
    echo 'file="'${boot_img##*/}'"		main_type="PARTITION"		sub_type="boot"' >> ${BINARIES_DIR}/image.cfg
    echo 'file="'${kernel_img##*/}'"		main_type="PARTITION"		sub_type="kernela"' >> ${BINARIES_DIR}/image.cfg
    echo 'file="'${rootfs_img##*/}'"		main_type="PARTITION"		sub_type="systema"' >> ${BINARIES_DIR}/image.cfg
    echo 'file="'${overlay_img##*/}'"		main_type="PARTITION"		sub_type="overlay"' >> ${BINARIES_DIR}/image.cfg
    echo 'file="'${data_img##*/}'"		main_type="PARTITION"		sub_type="data"' >> ${BINARIES_DIR}/image.cfg

    create_platform_conf

    cc -o $BINARIES_DIR/dtbTool $BOARD_DIR/../src/dtbTool.c
    $BINARIES_DIR/dtbTool -o $BINARIES_DIR/_aml_dtb.PARTITION ${BINARIES_DIR}/
    $BOARD_DIR/../bin/aml_image_v2_packer -r ${BINARIES_DIR}/image.cfg ${BINARIES_DIR}/ $hdd_img
    echo "Image created"
}
