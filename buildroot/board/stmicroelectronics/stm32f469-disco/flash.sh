#!/bin/bash

OUTPUT_DIR=$1

if ! test -d "${OUTPUT_DIR}" ; then
    echo "ERROR: no output directory specified."
    echo "Usage: $0 OUTPUT_DIR"
    exit 1
fi

${OUTPUT_DIR}/host/bin/openocd -f board/stm32f469discovery.cfg \
  -c "init" \
  -c "reset init" \
  -c "flash probe 0" \
  -c "flash info 0" \
  -c "flash write_image erase ${OUTPUT_DIR}/images/u-boot.bin 0x08000000" \
  -c "reset run" \
  -c "shutdown"
