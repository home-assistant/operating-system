#!/bin/bash
set -e

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="$BOARD_DIR/genimage.cfg"
GENIMAGE_TMP="$BASE_DIR/genimage.tmp"

OVERLAY_IMG="$BINARIES_DIR/overlay.ext4"
DATA_IMG="$BINARIES_DIR/data.ext4"

rm -rf "$GENIMAGE_TMP" "$OVERLAY_IMG" "$DATA_IMG"

dd if=/dev/zero of="$OVERLAY_IMG" bs=4k count=16000
dd if=/dev/zero of="$DATA_IMG" bs=4k count=16000

mkfs.ext4 "$OVERLAY_IMG" && tune2fs -L "overlay" -c0 -i0 "$OVERLAY_IMG"
mkfs.ext4 "$DATA_IMG" && tune2fs -L "data" -c0 -i0 "$DATA_IMG"

genimage \
    --rootpath "$TARGET_DIR" \
    --tmppath "$GENIMAGE_TMP" \
    --inputpath "$BINARIES_DIR" \
    --outputpath "$BINARIES_DIR" \
    --config "$GENIMAGE_CFG"

qemu-img resize -f raw "$BINARIES_DIR/sdcard.img" 1G
qemu-img convert -O vmdk "$BINARIES_DIR/sdcard.img" "$BINARIES_DIR/hassio-os.vmdk"

