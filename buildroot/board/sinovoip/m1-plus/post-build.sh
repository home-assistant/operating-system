#!/bin/sh

# Remove all but the brcmfmac43362 firmware files
find $TARGET_DIR/lib/firmware/brcm -type f -not -name "brcmfmac43362*" -delete
