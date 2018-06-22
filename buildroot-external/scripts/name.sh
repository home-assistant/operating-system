#!/bin/bash

function hassos_image_name() {
    echo "${HASSOS_ID}_${BOARD_ID}-${VERSION_MAJOR}.${VERSION_BUILD}"
}

function hassos_rauc_compatible() {
    echo "${HASSOS_ID}-${BOARD_ID}"
}
