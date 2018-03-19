#!/bin/bash
set -e

BOARD_DIR="$(dirname $0)"

cp "$BOARD_DIR/rauc.conf" "$TARGET_DIR/etc/rauc/system.conf"
