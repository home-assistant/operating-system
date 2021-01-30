/*
 *  Copyright (C) 2018 Realtek Semiconductor Corporation.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 */

struct rtb_struct;

#define BAUDRATE_4BYTES

#define ROM_LMP_NONE            0x0000
#define ROM_LMP_8723a           0x1200
#define ROM_LMP_8723b           0x8723
#define ROM_LMP_8821a           0x8821
#define ROM_LMP_8761a           0x8761
#define ROM_LMP_8761btc		0x8763

#define ROM_LMP_8703a           0x87b3
#define ROM_LMP_8763a           0x8763
#define ROM_LMP_8703b           0x8703
#define ROM_LMP_8723c           0x87c3 /* ??????? */
#define ROM_LMP_8822b           0x8822
#define ROM_LMP_8822c           0x8822
#define ROM_LMP_8723cs_xx       0x8704
#define ROM_LMP_8723cs_cg       0x8705
#define ROM_LMP_8723cs_vf       0x8706

/* Chip type */
#define CHIP_8703AS    1
#define CHIP_8723CS_CG 3
#define CHIP_8723CS_VF 4
#define CHIP_8723CS_XX 5
#define CHIP_8703BS   7

/* software id */
#define CHIP_UNKNOWN	0x00
#define CHIP_8761AT	0x1F
#define CHIP_8761ATF	0x2F
#define CHIP_8761BTC	0x3F
#define CHIP_8761BH4	0x4F
#define CHIP_8723BS	0x5F
#define CHIP_BEFORE	0x6F
#define CHIP_8822BS	0x70
#define CHIP_8723DS	0x71
#define CHIP_8821CS	0x72
#define CHIP_8822CS	0x73
#define CHIP_8761B	0x74

#define RTL_FW_MATCH_CHIP_TYPE  (1 << 0)
#define RTL_FW_MATCH_HCI_VER    (1 << 1)
#define RTL_FW_MATCH_HCI_REV    (1 << 2)
struct patch_info {
	uint32_t    match_flags;
	uint8_t     chip_type;
	uint16_t    lmp_subver;
	uint16_t    proj_id;
	uint8_t     hci_ver;
	uint16_t    hci_rev;
	char        *patch_file;
	char        *config_file;
	char        *ic_name;
};

struct patch_info *get_patch_entry(struct rtb_struct *btrtl);
uint8_t *rtb_read_config(const char *file, int *cfg_len, uint8_t chip_type);
uint8_t *rtb_read_firmware(struct rtb_struct *btrtl, int *fw_len);
uint8_t *rtb_get_final_patch(int fd, int proto, int *rlen);
