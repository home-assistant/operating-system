#!/bin/sh

BOARD_DIR="$(dirname $0)"

${HOST_DIR}/bin/fip_create \
	--bl30 ${BINARIES_DIR}/bl30.bin \
	--bl301 ${BINARIES_DIR}/bl301.bin \
	--bl31 ${BINARIES_DIR}/bl31.bin \
	--bl33 ${BINARIES_DIR}/u-boot.bin \
	${BINARIES_DIR}/fip.bin

${HOST_DIR}/bin/fip_create --dump ${BINARIES_DIR}/fip.bin

cat ${BINARIES_DIR}/bl2.package ${BINARIES_DIR}/fip.bin \
	> ${BINARIES_DIR}/boot_new.bin

${HOST_DIR}/bin/amlbootsig ${BINARIES_DIR}/boot_new.bin ${BINARIES_DIR}/u-boot.img

dd if=${BINARIES_DIR}/u-boot.img of=${BINARIES_DIR}/uboot-odc2.img bs=512 skip=96

support/scripts/genimage.sh -c ${BOARD_DIR}/genimage.cfg
