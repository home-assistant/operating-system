#!/bin/bash
set -e

VboxManage createvm --name Hass.io --ostype Linux_64 --register
VBoxManage modifyvm Hass.io --cpus 2 --memory 1048 --firmware efi
VBoxManage modifyvm Hass.io --nic1 bridged
VBoxManage storageattach Hass.io --storagectl "SATA Controller" --device 0 --port 0 --type vmdk --medium $1

VBoxManage export Hass.io --ovf20 --vendor "Home Assistant" --vendorurl "http://hass.io" --output $2
