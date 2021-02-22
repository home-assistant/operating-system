#!/bin/bash
# shellcheck disable=SC2155
# shellcheck disable=SC2034

# Change size partitions
BOOT_SIZE=(64M)
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
  echo "${0##*/}"
}


function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    echo "console=tty0 console=ttyAML0,115200n8" > "${BOOT_DATA}/cmdline.txt"
    cp "${BINARIES_DIR}/meson-axg-jethome-jethub-j100.dtb" "${BOOT_DATA}/meson-axg-jethome-jethub-j100.dtb"
    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
}

function hassos_post_image() {
    convert_disk_image_xz
}

function create_disk_image() {
    _prepare_disk_image
    _create_disk_aml
}

function create_platform_conf () {
    {
      echo "Platform:0x0811"
      echo "DDRLoad:0xfffc0000"
      echo "DDRRun:0xfffc0000"
      echo "UbootLoad:0x200c000"
      echo "UbootRun:0xfffc0000"
      echo "Control0=0xfffc0000:0x000000b1"
      echo "Control1=0xfffc0000:0x00005183"
      echo "Encrypt_reg:0xff800228"
      echo "bl2ParaAddr=0xfffcc000"
    } > "${BINARIES_DIR}/platform.conf"
}

function _create_disk_aml() {
    local boot_img="$(path_boot_img)"
    local rootfs_img="$(path_rootfs_img)"
    local overlay_img="$(path_overlay_img)"
    local data_img="$(path_data_img)"
    local kernel_img="$(path_kernel_img)"
    local hdd_img="$(hassos_image_name img)"
    local bootloader_img="u-boot.bin" # bootloader
    local ubootbin_img="u-boot.bin.usb.tpl" # UBOOT
    local ddrbin_img="u-boot.bin.usb.bl2" # DDR

    {
      echo "[LIST_NORMAL]"
      echo 'file="'"${ddrbin_img}"'"		main_type="USB"		sub_type="DDR"'
      echo 'file="'"${ubootbin_img}"'"		main_type="USB"		sub_type="UBOOT"'
      echo 'file="_aml_dtb.PARTITION"		main_type="dtb"		sub_type="meson1"'
      echo 'file="platform.conf"		main_type="conf"		sub_type="platform"'
      echo ""
      echo "[LIST_VERIFY]"
      echo 'file="_aml_dtb.PARTITION"	main_type="PARTITION"		sub_type="_aml_dtb"'
      echo 'file="'"${bootloader_img}"'"	main_type="PARTITION"		sub_type="bootloader"'
      echo 'file="'"${boot_img##*/}"'"		main_type="PARTITION"		sub_type="boot"'
      echo 'file="'"${kernel_img##*/}"'"		main_type="PARTITION"		sub_type="kernela"'
      echo 'file="'"${rootfs_img##*/}"'"		main_type="PARTITION"		sub_type="systema"'
      echo 'file="'"${overlay_img##*/}"'"		main_type="PARTITION"		sub_type="overlay"'
      echo 'file="'"${data_img##*/}"'"		main_type="PARTITION"		sub_type="data"'
    } > "${BINARIES_DIR}/image.cfg"
    create_platform_conf

    "$BINARIES_DIR/dtbTool" -o "$BINARIES_DIR/_aml_dtb.PARTITION" "${BINARIES_DIR}/"
    "$BINARIES_DIR/aml_image_v2_packer_new" -r "${BINARIES_DIR}/image.cfg" "${BINARIES_DIR}/" "$hdd_img"
    echo "Image created"
}
