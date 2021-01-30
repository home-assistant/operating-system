/*
 *  Copyright (C) 2013 Realtek Semiconductor Corp.
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

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <termios.h>
#include <time.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/param.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/uio.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <stdint.h>
#include <string.h>
#include <endian.h>
#include <byteswap.h>
#include <netinet/in.h>
#include <poll.h>
#include <sys/timerfd.h>
#include <sys/epoll.h>

#include "rtb_fwc.h"
#include "hciattach.h"
#include "hciattach_h4.h"

#define RTK_VERSION "3.1"

#define TIMESTAMP_PR

#define MAX_EVENTS 10

/* #define SERIAL_NONBLOCK_READ */

#ifdef SERIAL_NONBLOCK_READ
#define FD_BLOCK	0
#define FD_NONBLOCK	1
#endif

/* #define RTL_8703A_SUPPORT */
/* #define RTL8723DSH4_UART_HWFLOWC */ /* 8723DS H4 special */

uint8_t DBG_ON = 1;

#define HCI_EVENT_HDR_SIZE          2
#define PATCH_DATA_FIELD_MAX_SIZE   252

#define HCI_CMD_READ_BD_ADDR		0x1009
#define HCI_VENDOR_CHANGE_BAUD		0xfc17
#define HCI_VENDOR_READ_ROM_VER		0xfc6d
#define HCI_CMD_READ_LOCAL_VER		0x1001
#define HCI_VENDOR_READ_CHIP_TYPE	0xfc61
#define HCI_CMD_RESET			0x0c03

/* HCI data types */
#define H5_ACK_PKT              0x00
#define HCI_COMMAND_PKT         0x01
#define HCI_ACLDATA_PKT         0x02
#define HCI_SCODATA_PKT         0x03
#define HCI_EVENT_PKT           0x04
#define H5_VDRSPEC_PKT          0x0E
#define H5_LINK_CTL_PKT         0x0F

#define H5_HDR_SEQ(hdr)         ((hdr)[0] & 0x07)
#define H5_HDR_ACK(hdr)         (((hdr)[0] >> 3) & 0x07)
#define H5_HDR_CRC(hdr)         (((hdr)[0] >> 6) & 0x01)
#define H5_HDR_RELIABLE(hdr)    (((hdr)[0] >> 7) & 0x01)
#define H5_HDR_PKT_TYPE(hdr)    ((hdr)[1] & 0x0f)
#define H5_HDR_LEN(hdr)         ((((hdr)[1] >> 4) & 0xff) + ((hdr)[2] << 4))
#define H5_HDR_SIZE             4

struct sk_buff {
	uint32_t max_len;
	uint32_t data_len;
	uint8_t *data;
};

struct hci_ev_cmd_complete {
	uint8_t ncmd;
	uint16_t opcode;
} __attribute__ ((packed));

#define OP_H5_SYNC		0x01
#define OP_H5_CONFIG		0x02
#define OP_ROM_VER		((1 << 24) | HCI_VENDOR_READ_ROM_VER)
#define OP_LMP_VER		((1 << 24) | HCI_CMD_READ_LOCAL_VER)
#define OP_CHIP_TYPE		((1 << 24) | HCI_VENDOR_READ_CHIP_TYPE)
#define OP_SET_BAUD		((1 << 24) | HCI_VENDOR_CHANGE_BAUD)
#define OP_HCI_RESET		((1 << 24) | HCI_CMD_RESET)

struct rtb_struct rtb_cfg;

/* bite reverse in bytes
 * 00000001 -> 10000000
 * 00000100 -> 00100000
 */
const uint8_t byte_rev_table[256] = {
	0x00, 0x80, 0x40, 0xc0, 0x20, 0xa0, 0x60, 0xe0,
	0x10, 0x90, 0x50, 0xd0, 0x30, 0xb0, 0x70, 0xf0,
	0x08, 0x88, 0x48, 0xc8, 0x28, 0xa8, 0x68, 0xe8,
	0x18, 0x98, 0x58, 0xd8, 0x38, 0xb8, 0x78, 0xf8,
	0x04, 0x84, 0x44, 0xc4, 0x24, 0xa4, 0x64, 0xe4,
	0x14, 0x94, 0x54, 0xd4, 0x34, 0xb4, 0x74, 0xf4,
	0x0c, 0x8c, 0x4c, 0xcc, 0x2c, 0xac, 0x6c, 0xec,
	0x1c, 0x9c, 0x5c, 0xdc, 0x3c, 0xbc, 0x7c, 0xfc,
	0x02, 0x82, 0x42, 0xc2, 0x22, 0xa2, 0x62, 0xe2,
	0x12, 0x92, 0x52, 0xd2, 0x32, 0xb2, 0x72, 0xf2,
	0x0a, 0x8a, 0x4a, 0xca, 0x2a, 0xaa, 0x6a, 0xea,
	0x1a, 0x9a, 0x5a, 0xda, 0x3a, 0xba, 0x7a, 0xfa,
	0x06, 0x86, 0x46, 0xc6, 0x26, 0xa6, 0x66, 0xe6,
	0x16, 0x96, 0x56, 0xd6, 0x36, 0xb6, 0x76, 0xf6,
	0x0e, 0x8e, 0x4e, 0xce, 0x2e, 0xae, 0x6e, 0xee,
	0x1e, 0x9e, 0x5e, 0xde, 0x3e, 0xbe, 0x7e, 0xfe,
	0x01, 0x81, 0x41, 0xc1, 0x21, 0xa1, 0x61, 0xe1,
	0x11, 0x91, 0x51, 0xd1, 0x31, 0xb1, 0x71, 0xf1,
	0x09, 0x89, 0x49, 0xc9, 0x29, 0xa9, 0x69, 0xe9,
	0x19, 0x99, 0x59, 0xd9, 0x39, 0xb9, 0x79, 0xf9,
	0x05, 0x85, 0x45, 0xc5, 0x25, 0xa5, 0x65, 0xe5,
	0x15, 0x95, 0x55, 0xd5, 0x35, 0xb5, 0x75, 0xf5,
	0x0d, 0x8d, 0x4d, 0xcd, 0x2d, 0xad, 0x6d, 0xed,
	0x1d, 0x9d, 0x5d, 0xdd, 0x3d, 0xbd, 0x7d, 0xfd,
	0x03, 0x83, 0x43, 0xc3, 0x23, 0xa3, 0x63, 0xe3,
	0x13, 0x93, 0x53, 0xd3, 0x33, 0xb3, 0x73, 0xf3,
	0x0b, 0x8b, 0x4b, 0xcb, 0x2b, 0xab, 0x6b, 0xeb,
	0x1b, 0x9b, 0x5b, 0xdb, 0x3b, 0xbb, 0x7b, 0xfb,
	0x07, 0x87, 0x47, 0xc7, 0x27, 0xa7, 0x67, 0xe7,
	0x17, 0x97, 0x57, 0xd7, 0x37, 0xb7, 0x77, 0xf7,
	0x0f, 0x8f, 0x4f, 0xcf, 0x2f, 0xaf, 0x6f, 0xef,
	0x1f, 0x9f, 0x5f, 0xdf, 0x3f, 0xbf, 0x7f, 0xff,
};

static __inline uint8_t bit_rev8(uint8_t byte)
{
	return byte_rev_table[byte];
}

static __inline uint16_t bit_rev16(uint16_t x)
{
	return (bit_rev8(x & 0xff) << 8) | bit_rev8(x >> 8);
}

static const uint16_t crc_table[] = {
	0x0000, 0x1081, 0x2102, 0x3183,
	0x4204, 0x5285, 0x6306, 0x7387,
	0x8408, 0x9489, 0xa50a, 0xb58b,
	0xc60c, 0xd68d, 0xe70e, 0xf78f
};

/* Initialise the crc calculator */
#define H5_CRC_INIT(x) x = 0xffff

static __inline struct sk_buff *skb_alloc(unsigned int len)
{
	struct sk_buff *skb = NULL;

	if ((skb = malloc(len + sizeof(*skb)))) {
		skb->max_len = len;
		skb->data_len = 0;
		skb->data = ((uint8_t *)skb) + sizeof(*skb);
	} else {
		RS_ERR("Allocate skb fails!");
		skb = NULL;
		return NULL;
	}
	memset(skb->data, 0, len);
	return skb;
}

static __inline void skb_free(struct sk_buff *skb)
{
	free(skb);
	return;
}

/*
 * Add data to a buffer
 * This function extends the used data area of the buffer.
 */
static uint8_t *skb_put(struct sk_buff *skb, uint32_t len)
{
	uint32_t old_len = skb->data_len;

	if ((skb->data_len + len) > (skb->max_len)) {
		RS_ERR("Buffer too small");
		exit(EXIT_FAILURE);
	}
	skb->data_len += len;
	return (skb->data + old_len);
}

/*
 * Remove end from a buffer
 * Cut the length of a buffer down by removing data from the tail
 */
static void skb_trim(struct sk_buff *skb, uint32_t len)
{
	if (skb->data_len > len) {
		skb->data_len = len;
	} else {
		RS_ERR("Trim error, data_len %u < len %u", skb->data_len, len);
	}
}

/*
 * Remove data from the start of a buffer
 * This function removes data from the start of a buffer.
 * A pointer to the next data in the buffer is returned
 */
static uint8_t *skb_pull(struct sk_buff *skb, uint32_t len)
{
	if (len > skb->data_len) {
		RS_ERR("Pull error, data_len %u < len %u", skb->data_len, len);
		exit(EXIT_FAILURE);
	}
	skb->data_len -= len;
	skb->data += len;
	return skb->data;
}

/**
* Add "d" into crc scope, caculate the new crc value
*
* @param crc crc data
* @param d one byte data
*/
static void h5_crc_update(uint16_t * crc, uint8_t d)
{
	uint16_t reg = *crc;

	reg = (reg >> 4) ^ crc_table[(reg ^ d) & 0x000f];
	reg = (reg >> 4) ^ crc_table[(reg ^ (d >> 4)) & 0x000f];

	*crc = reg;
}

struct __una_u16 {
	uint16_t x;
};
static __inline uint16_t __get_unaligned_cpu16(const void *p)
{
	const struct __una_u16 *ptr = (const struct __una_u16 *)p;
	return ptr->x;
}

static __inline uint16_t get_unaligned_be16(const void *p)
{
	return __get_unaligned_cpu16((const uint8_t *)p);
}

/*
 * Get crc data.
 */
static uint16_t h5_get_crc(struct rtb_struct * h5)
{
	uint16_t crc = 0;
	uint8_t *data = h5->rx_skb->data + h5->rx_skb->data_len - 2;

	crc = data[1] + (data[0] << 8);
	return crc;
	/* return get_unaligned_be16(&h5->rx_skb->data[h5->rx_skb->data_len - 2]); */
}

/*
 * Add 0xc0 to buffer.
 */
static void h5_slip_msgdelim(struct sk_buff *skb)
{
	const char pkt_delim = 0xc0;
	memcpy(skb_put(skb, 1), &pkt_delim, 1);
}

/*
 * Encode one byte in h5 proto
 * 0xc0 -> 0xdb, 0xdc
 * 0xdb -> 0xdb, 0xdd
 * 0x11 -> 0xdb, 0xde
 * 0x13 -> 0xdb, 0xdf
 * others will not change
 */
static void h5_slip_one_byte(struct sk_buff *skb, uint8_t c)
{
	const uint8_t esc_c0[2] = { 0xdb, 0xdc };
	const uint8_t esc_db[2] = { 0xdb, 0xdd };
	const uint8_t esc_11[2] = { 0xdb, 0xde };
	const uint8_t esc_13[2] = { 0xdb, 0xdf };

	switch (c) {
	case 0xc0:
		memcpy(skb_put(skb, 2), &esc_c0, 2);
		break;

	case 0xdb:
		memcpy(skb_put(skb, 2), &esc_db, 2);
		break;

	case 0x11:
		memcpy(skb_put(skb, 2), &esc_11, 2);
		break;

	case 0x13:
		memcpy(skb_put(skb, 2), &esc_13, 2);
		break;

	default:
		memcpy(skb_put(skb, 1), &c, 1);
		break;
	}
}

/*
 * Decode one byte in h5 proto
 * 0xdb, 0xdc -> 0xc0
 * 0xdb, 0xdd -> 0xdb
 * 0xdb, 0xde -> 0x11
 * 0xdb, 0xdf -> 0x13
 * others will not change
 */
static void h5_unslip_one_byte(struct rtb_struct * h5, unsigned char byte)
{
	const uint8_t c0 = 0xc0, db = 0xdb;
	const uint8_t oof1 = 0x11, oof2 = 0x13;

	if (H5_ESCSTATE_NOESC == h5->rx_esc_state) {
		if (0xdb == byte) {
			h5->rx_esc_state = H5_ESCSTATE_ESC;
		} else {
			memcpy(skb_put(h5->rx_skb, 1), &byte, 1);
			/* Check Pkt Header's CRC enable bit */
			if ((h5->rx_skb->data[0] & 0x40) != 0 &&
			    h5->rx_state != H5_W4_CRC) {
				h5_crc_update(&h5->message_crc, byte);
			}
			h5->rx_count--;
		}
	} else if (H5_ESCSTATE_ESC == h5->rx_esc_state) {
		switch (byte) {
		case 0xdc:
			memcpy(skb_put(h5->rx_skb, 1), &c0, 1);
			if ((h5->rx_skb->data[0] & 0x40) != 0 &&
			    h5->rx_state != H5_W4_CRC)
				h5_crc_update(&h5->message_crc, 0xc0);
			h5->rx_esc_state = H5_ESCSTATE_NOESC;
			h5->rx_count--;
			break;

		case 0xdd:
			memcpy(skb_put(h5->rx_skb, 1), &db, 1);
			if ((h5->rx_skb->data[0] & 0x40) != 0 &&
			    h5->rx_state != H5_W4_CRC)
				h5_crc_update(&h5->message_crc, 0xdb);
			h5->rx_esc_state = H5_ESCSTATE_NOESC;
			h5->rx_count--;
			break;

		case 0xde:
			memcpy(skb_put(h5->rx_skb, 1), &oof1, 1);
			if ((h5->rx_skb->data[0] & 0x40) != 0 &&
			    h5->rx_state != H5_W4_CRC)
				h5_crc_update(&h5->message_crc, oof1);
			h5->rx_esc_state = H5_ESCSTATE_NOESC;
			h5->rx_count--;
			break;

		case 0xdf:
			memcpy(skb_put(h5->rx_skb, 1), &oof2, 1);
			if ((h5->rx_skb->data[0] & 0x40) != 0 &&
			    h5->rx_state != H5_W4_CRC)
				h5_crc_update(&h5->message_crc, oof2);
			h5->rx_esc_state = H5_ESCSTATE_NOESC;
			h5->rx_count--;
			break;

		default:
			RS_ERR("Error: Invalid byte %02x after esc byte", byte);
			skb_free(h5->rx_skb);
			h5->rx_skb = NULL;
			h5->rx_state = H5_W4_PKT_DELIMITER;
			h5->rx_count = 0;
			break;
		}
	}
}

/*
 * Prepare h5 packet
 * Refer to Core Spec Vol 4, Part D
 * Three-wire UART Transport Layer: 4 PACKET HEADER
 */
static struct sk_buff *h5_prepare_pkt(struct rtb_struct * h5, uint8_t *data,
				      int len, int pkt_type)
{
	struct sk_buff *nskb;
	uint8_t hdr[4];
	uint16_t H5_CRC_INIT(h5_txmsg_crc);
	int rel, i;

	switch (pkt_type) {
	case HCI_ACLDATA_PKT:
	case HCI_COMMAND_PKT:
	case HCI_EVENT_PKT:
		rel = 1; /* reliable */
		break;

	case H5_ACK_PKT:
	case H5_VDRSPEC_PKT:
	case H5_LINK_CTL_PKT:
		rel = 0; /* unreliable */
		break;

	default:
		RS_ERR("Unknown packet type");
		return NULL;
	}

	/* Max len of packet: (len + 4(h5 hdr) + 2(crc))*2
	 * Because bytes 0xc0 and 0xdb are escaped, worst case is that the
	 * packet is only made of 0xc0 and 0xdb
	 * The additional 2-octets are 0xc0 delimiters at start and end of each
	 * packet.
	 */
	nskb = skb_alloc((len + 6) * 2 + 2);
	if (!nskb)
		return NULL;

	/* Add SLIP start byte: 0xc0 */
	h5_slip_msgdelim(nskb);
	/* Set ack number in SLIP header */
	hdr[0] = h5->rxseq_txack << 3;
	h5->is_txack_req = 0;

	/* RS_DBG("Request packet no(%u) to card", h5->rxseq_txack); */
	/* RS_DBG("Sending packet with seqno %u and wait %u", h5->msgq_txseq,
	 *        h5->rxseq_txack);
	 */
	if (rel) {
		/* Set reliable bit and seq number */
		hdr[0] |= 0x80 + h5->msgq_txseq;
		/* RS_DBG("Sending packet with seqno(%u)", h5->msgq_txseq); */
		++(h5->msgq_txseq);
		h5->msgq_txseq = (h5->msgq_txseq) & 0x07;
	}
	/* Set DIC Present bit */
	if (h5->use_crc)
		hdr[0] |= 0x40;

	/* Set packet type and payload length */
	hdr[1] = ((len << 4) & 0xff) | pkt_type;
	hdr[2] = (uint8_t) (len >> 4);
	/* Set header checksum */
	hdr[3] = ~(hdr[0] + hdr[1] + hdr[2]);

	/* Encode h5 header */
	for (i = 0; i < 4; i++) {
		h5_slip_one_byte(nskb, hdr[i]);

		if (h5->use_crc)
			h5_crc_update(&h5_txmsg_crc, hdr[i]);
	}

	/* Encode payload */
	for (i = 0; i < len; i++) {
		h5_slip_one_byte(nskb, data[i]);

		if (h5->use_crc)
			h5_crc_update(&h5_txmsg_crc, data[i]);
	}

	/* Encode CRC */
	if (h5->use_crc) {
		h5_txmsg_crc = bit_rev16(h5_txmsg_crc);
		h5_slip_one_byte(nskb, (uint8_t) ((h5_txmsg_crc >> 8) & 0x00ff));
		h5_slip_one_byte(nskb, (uint8_t) (h5_txmsg_crc & 0x00ff));
	}
	/* Add 0xc0 at the end of the packet */
	h5_slip_msgdelim(nskb);

	return nskb;
}

/*
 * Remove controller acked packet from host unacked lists
 */
/* static void h5_remove_acked_pkt(struct rtb_struct * h5)
 * {
 * 	int pkts_to_be_removed = 0;
 * 	int seqno = 0;
 * 	int i = 0;
 * 
 * 	seqno = h5->msgq_txseq;
 * 	// pkts_to_be_removed = GetListLength(h5->unacked);
 * 
 * 	while (pkts_to_be_removed) {
 * 		if (h5->rxack == seqno)
 * 			break;
 * 
 * 		pkts_to_be_removed--;
 * 		seqno = (seqno - 1) & 0x07;
 * 	}
 * 
 * 	if (h5->rxack != seqno) {
 * 		RS_DBG("Peer acked invalid packet");
 * 	}
 * 	// skb_queue_walk_safe(&h5->unack, skb, tmp)
 * 	// remove ack'ed packet from h5->unack queue
 * 	for (i = 0; i < 5; ++i) {
 * 		if (i >= pkts_to_be_removed)
 * 			break;
 * 		i++;
 * 		//__skb_unlink(skb, &h5->unack);
 * 		//skb_free(skb);
 * 	}
 * 
 * 	//  if (skb_queue_empty(&h5->unack))
 * 	//          del_timer(&h5->th5);
 * 	//  spin_unlock_irqrestore(&h5->unack.lock, flags);
 * 
 * 	if (i != pkts_to_be_removed)
 * 		RS_DBG("Removed only (%u) out of (%u) pkts", i,
 * 		       pkts_to_be_removed);
 * }
 */

/*
 * Send host ack.
 */
static void rtb_send_ack(int fd)
{
	int len;
	struct sk_buff *nskb = h5_prepare_pkt(&rtb_cfg, NULL, 0, H5_ACK_PKT);

	len = write(fd, nskb->data, nskb->data_len);
	if (len != nskb->data_len)
		RS_ERR("Write pure ack fails");

	skb_free(nskb);
	return;
}

/*
 * Parse hci command complete event in h5 init state.
 */
static void h5_init_hci_cc(struct sk_buff *skb)
{
	struct hci_ev_cmd_complete *ev = NULL;
	uint16_t opcode = 0;
	uint8_t status = 0;

	skb_pull(skb, HCI_EVENT_HDR_SIZE);
	ev = (struct hci_ev_cmd_complete *)skb->data;
	opcode = le16_to_cpu(ev->opcode);

	RS_DBG("Receive cmd complete event of command: %04x", opcode);

	skb_pull(skb, sizeof(struct hci_ev_cmd_complete));

	status = skb->data[0];
	if (status) {
		RS_ERR("status is %u for cmd %04x", status, opcode);
		return;
	}

	if (rtb_cfg.cmd_state.opcode != opcode) {
		RS_ERR("%s: Received unexpected cc for cmd %04x, %04x of cc",
		       __func__, rtb_cfg.cmd_state.opcode, opcode);
		return;
	}

	rtb_cfg.cmd_state.state = CMD_STATE_SUCCESS;

	switch (opcode) {
	case HCI_VENDOR_CHANGE_BAUD:
		RS_INFO("Received cc of vendor change baud");
		break;
	case HCI_CMD_READ_BD_ADDR:
		RS_INFO("BD Address: %02x:%02x:%02x:%02x:%02x:%02x",
			skb->data[5], skb->data[4], skb->data[3],
			skb->data[2], skb->data[1], skb->data[0]);
		break;

	case HCI_CMD_READ_LOCAL_VER:
		rtb_cfg.hci_ver = skb->data[1];
		rtb_cfg.hci_rev = (skb->data[2] | skb->data[3] << 8);
		rtb_cfg.lmp_subver = (skb->data[7] | (skb->data[8] << 8));
		RS_INFO("HCI Version 0x%02x", rtb_cfg.hci_ver);
		RS_INFO("HCI Revision 0x%04x", rtb_cfg.hci_rev);
		RS_INFO("LMP Subversion 0x%04x", rtb_cfg.lmp_subver);
		break;

	case HCI_VENDOR_READ_ROM_VER:
		rtb_cfg.eversion = skb->data[1];
		RS_INFO("Read ROM version %02x", rtb_cfg.eversion);
		break;

	case HCI_VENDOR_READ_CHIP_TYPE:
		rtb_cfg.chip_type = (skb->data[1] & 0x0f);
		RS_INFO("Read chip type %02x", rtb_cfg.chip_type);
		break;
	default:
		return;
	}

	/* Count the cmd num for makeing the seq number aligned */
	rtb_cfg.num_of_cmd_sent++;
}

/*
 * Parse hci command complete event in h5 post state.
 */
static void h5_post_hci_cc(struct sk_buff *skb)
{
	struct hci_ev_cmd_complete *ev = NULL;
	uint16_t opcode = 0;
	uint8_t status = 0;

	skb_pull(skb, HCI_EVENT_HDR_SIZE);
	ev = (struct hci_ev_cmd_complete *)skb->data;
	opcode = le16_to_cpu(ev->opcode);

	RS_DBG("Receive cmd complete event of command: %04x", opcode);

	skb_pull(skb, sizeof(struct hci_ev_cmd_complete));

	status = skb->data[0];
	if (status) {
		RS_ERR("status is %u for cmd %04x", status, opcode);
		return;
	}

	if (rtb_cfg.cmd_state.opcode != opcode) {
		RS_ERR("%s: Received unexpected cc for cmd %04x, %04x of cc",
		       __func__, rtb_cfg.cmd_state.opcode, opcode);
		return;
	}

	rtb_cfg.cmd_state.state = CMD_STATE_SUCCESS;

	switch (opcode) {
	case HCI_CMD_RESET:
		RS_INFO("Received cc of hci reset cmd");
		rtb_cfg.link_estab_state = H5_ACTIVE;
		break;
	default:
		break;
	}
}

/*
 * Process a hci frame
 */
static void hci_recv_frame(struct sk_buff *skb)
{
	if (rtb_cfg.link_estab_state == H5_INIT) {
		if (skb->data[0] == 0x0e)
			h5_init_hci_cc(skb);

		/*
		 * rtb_send_ack(rtb_cfg.serial_fd);
		 * usleep(10000);
		 * rtb_send_ack(rtb_cfg.serial_fd);
		 */
	} else if (rtb_cfg.link_estab_state == H5_PATCH) {
		if (skb->data[0] != 0x0e) {
			RS_INFO("Received event 0x%x during download patch",
				skb->data[0]);
			return;
		}

		rtb_cfg.rx_index = skb->data[6];

		/* RS_INFO("rx_index %d", rtb_cfg.rx_index); */

		/* Download fw/config done */
		if (rtb_cfg.rx_index & 0x80) {
			rtb_cfg.rx_index &= ~0x80;
			rtb_cfg.link_estab_state = H5_HCI_RESET;
		}
	} else if (rtb_cfg.link_estab_state == H5_HCI_RESET) {
		if (skb->data[0] == 0x0e)
			h5_post_hci_cc(skb);
	} else {
		RS_ERR("receive packets in active state");
	}
}

static void h5_handle_internal_rx(struct sk_buff *skb)
{
	int len;
	uint8_t sync_req[2] = { 0x01, 0x7E };
	uint8_t sync_resp[2] = { 0x02, 0x7D };
	uint8_t sync_resp_pkt[0x8] = {
		0xc0, 0x00, 0x2F, 0x00, 0xD0, 0x02, 0x7D, 0xc0
	};
	uint8_t conf_req[2] = { 0x03, 0xFC };
	uint8_t conf_resp[2] = { 0x04, 0x7B };
	uint8_t conf_resp_pkt[0x8] = {
		0xc0, 0x00, 0x2F, 0x00, 0xD0, 0x04, 0x7B, 0xc0
	};

	if (rtb_cfg.link_estab_state == H5_SYNC) {
		if (!memcmp(skb->data, sync_req, 2)) {
			RS_INFO("[SYNC] Get SYNC Pkt\n");
			len = write(rtb_cfg.serial_fd, sync_resp_pkt, 0x8);
			if (len != 0x08)
				RS_ERR("Send h5 sync resp error, %s",
				       strerror(errno));
		} else if (!memcmp(skb->data, sync_resp, 2)) {
			RS_INFO("[SYNC] Get SYNC Resp Pkt");
			rtb_cfg.link_estab_state = H5_CONFIG;
		}
	} else if (rtb_cfg.link_estab_state == H5_CONFIG) {
		if (!memcmp(skb->data, sync_req, 0x2)) {
			RS_INFO("[CONFIG] Get SYNC pkt");
			len = write(rtb_cfg.serial_fd, sync_resp_pkt, 0x8);
			if (len != 0x08)
				RS_ERR("Send h5 sync resp error, %s",
				       strerror(errno));
		} else if (!memcmp(skb->data, conf_req, 0x2)) {
			RS_INFO("[CONFIG] Get CONFG pkt");
			len = write(rtb_cfg.serial_fd, conf_resp_pkt, 0x8);
			if (len != 0x08)
				RS_ERR("Send h5 sync resp to ctl error, %s",
				       strerror(errno));
		} else if (!memcmp(skb->data, conf_resp, 0x2)) {
			RS_INFO("[CONFIG] Get CONFG resp pkt");
			/* Change state to H5_INIT after receiving a conf resp
			 */
			rtb_cfg.link_estab_state = H5_INIT;
			if (skb->data_len > 2) {
				rtb_cfg.use_crc = ((skb->data[2]) >> 4) & 0x01;
				RS_INFO("dic is %u, cfg field 0x%02x",
					rtb_cfg.use_crc, skb->data[2]);
			}
		} else {
			RS_WARN("[CONFIG] Get unknown pkt");
			rtb_send_ack(rtb_cfg.serial_fd);
		}
	}
}

/*
 * Process the received complete h5 packet
 */
static void h5_complete_rx_pkt(struct rtb_struct *h5)
{
	int pass_up = 1;
	uint8_t *h5_hdr = NULL;

	h5_hdr = (uint8_t *) (h5->rx_skb->data);
	if (H5_HDR_RELIABLE(h5_hdr)) {
		/* RS_DBG("Received reliable seqno %u from card", h5->rxseq_txack);
		 */
		h5->rxseq_txack = H5_HDR_SEQ(h5_hdr) + 1;
		/* h5->rxseq_txack %= 8; */
		h5->rxseq_txack &= 0x07;
		h5->is_txack_req = 1;
	}

	h5->rxack = H5_HDR_ACK(h5_hdr);

	switch (H5_HDR_PKT_TYPE(h5_hdr)) {
	case HCI_ACLDATA_PKT:
	case HCI_EVENT_PKT:
	case HCI_COMMAND_PKT:
		/* h5_remove_acked_pkt(h5); */
		pass_up = 1;
		break;
	case HCI_SCODATA_PKT:
		pass_up = 1;
		break;
	case H5_LINK_CTL_PKT:
		pass_up = 0;
		skb_pull(h5->rx_skb, H5_HDR_SIZE);
		h5_handle_internal_rx(h5->rx_skb);
		break;
	default: /* Pure ack or other unexpected pkt */
		pass_up = 0;
		break;
	}

	if (pass_up) {
		skb_pull(h5->rx_skb, H5_HDR_SIZE);
		hci_recv_frame(h5->rx_skb);
	}

	if (h5->is_txack_req) {
		rtb_send_ack(rtb_cfg.serial_fd);
		h5->is_txack_req = 0;
	}

	skb_free(h5->rx_skb);

	h5->rx_state = H5_W4_PKT_DELIMITER;
	h5->rx_skb = NULL;
}

/*
 * Parse the receive data in h5 proto.
 */
static int h5_recv(struct rtb_struct *h5, void *data, int count)
{
	unsigned char *ptr;
	ptr = (unsigned char *)data;

	while (count) {
		if (h5->rx_count) {
			if (*ptr == 0xc0) {
				RS_ERR("Short h5 packet");
				skb_free(h5->rx_skb);
				h5->rx_state = H5_W4_PKT_START;
				h5->rx_count = 0;
			} else
				h5_unslip_one_byte(h5, *ptr);

			ptr++;
			count--;
			continue;
		}

		switch (h5->rx_state) {
		case H5_W4_HDR:
			/* Check header checksum */
			if ((0xff & (uint8_t)~(h5->rx_skb->data[0] + h5->rx_skb->data[1] +
			     h5->rx_skb->data[2])) != h5->rx_skb->data[3]) {
				RS_ERR("h5 hdr checksum error");
				skb_free(h5->rx_skb);
				h5->rx_state = H5_W4_PKT_DELIMITER;
				h5->rx_count = 0;
				continue;
			}

			/* The received seq number is unexpected */
			if (h5->rx_skb->data[0] & 0x80 &&
			    (h5->rx_skb->data[0] & 0x07) != h5->rxseq_txack) {
				uint8_t rxseq_txack = (h5->rx_skb->data[0] & 0x07);
				RS_ERR("Out-of-order packet arrived, got(%u)expected(%u)",
				     h5->rx_skb->data[0] & 0x07,
				     h5->rxseq_txack);
				h5->is_txack_req = 1;

				skb_free(h5->rx_skb);
				h5->rx_state = H5_W4_PKT_DELIMITER;
				h5->rx_count = 0;

				/* Depend on whether Controller will reset ack
				 * number or not
				 */
				if (rtb_cfg.link_estab_state == H5_PATCH &&
				    rtb_cfg.tx_index == rtb_cfg.total_num)
					rtb_cfg.rxseq_txack = rxseq_txack;

				continue;
			}
			h5->rx_state = H5_W4_DATA;
			h5->rx_count =
			    (h5->rx_skb->data[1] >> 4) +
			    (h5->rx_skb->data[2] << 4);
			continue;

		case H5_W4_DATA:
			/* Packet with crc */
			if (h5->rx_skb->data[0] & 0x40) {
				h5->rx_state = H5_W4_CRC;
				h5->rx_count = 2;
			} else {
				h5_complete_rx_pkt(h5);
			}
			continue;

		case H5_W4_CRC:
			if (bit_rev16(h5->message_crc) != h5_get_crc(h5)) {
				RS_ERR("Checksum failed, computed %04x received %04x",
				       bit_rev16(h5->message_crc),
				       h5_get_crc(h5));
				skb_free(h5->rx_skb);
				h5->rx_state = H5_W4_PKT_DELIMITER;
				h5->rx_count = 0;
				continue;
			}
			skb_trim(h5->rx_skb, h5->rx_skb->data_len - 2);
			h5_complete_rx_pkt(h5);
			continue;

		case H5_W4_PKT_DELIMITER:
			switch (*ptr) {
			case 0xc0:
				h5->rx_state = H5_W4_PKT_START;
				break;

			default:
				break;
			}
			ptr++;
			count--;
			break;

		case H5_W4_PKT_START:
			switch (*ptr) {
			case 0xc0:
				ptr++;
				count--;
				break;

			default:
				h5->rx_state = H5_W4_HDR;
				h5->rx_count = 4;
				h5->rx_esc_state = H5_ESCSTATE_NOESC;
				H5_CRC_INIT(h5->message_crc);

				/* Do not increment ptr or decrement count
				 * Allocate packet. Max len of a H5 pkt=
				 * 0xFFF (payload) +4 (header) +2 (crc)
				 */
				h5->rx_skb = skb_alloc(0x1005);
				if (!h5->rx_skb) {
					RS_ERR("Can't alloc skb for new pkt");
					h5->rx_state = H5_W4_PKT_DELIMITER;
					h5->rx_count = 0;
					return 0;
				}
				break;
			}
			break;

		default:
			break;
		}
	}
	return count;
}

static const char *op_string(uint32_t op)
{
	switch (op) {
	case OP_SET_BAUD:
		return "OP_SET_BAUD";
	case OP_H5_SYNC:
		return "OP_H5_SYNC";
	case OP_H5_CONFIG:
		return "OP_H5_CONFIG";
	case OP_HCI_RESET:
		return "OP_HCI_RESET";
	case OP_CHIP_TYPE:
		return "OP_CHIP_TYPE";
	case OP_ROM_VER:
		return "OP_ROM_VER";
	case OP_LMP_VER:
		return "OP_LMP_VER";
	default:
		return "OP_UNKNOWN";
	}
}

static int start_transmit_wait(int fd, struct sk_buff *skb,
			       uint32_t op, unsigned int msec, int retry)
{
	unsigned char buf[128];
	ssize_t result;
	struct iovec iov;
	ssize_t ret;
	uint8_t *data;
	int len;
	int op_result = -1;
	uint64_t expired;
	int n;
	struct epoll_event events[MAX_EVENTS];
	int nfds;
	uint16_t opcode = 0;

	if (fd == -1 || !skb) {
		RS_ERR("Invalid parameter");
		return -1;
	}

	data = skb->data;
	len = skb->data_len;

	if (op & (1 << 24)) {
		opcode = (op & 0xffff);
		if (opcode != rtb_cfg.cmd_state.opcode ||
		    rtb_cfg.cmd_state.state != CMD_STATE_UNKNOWN) {
			RS_ERR("Invalid opcode or cmd state");
			return -1;
		}
	}

	iov.iov_base = data;
	iov.iov_len = len;
	do {
		ret = writev(fd, &iov, 1);
		if (ret != len)
			RS_WARN("Writev partially, ret %d", (int)ret);
	} while (ret < 0 && errno == EINTR);

	if (ret < 0) {
		RS_ERR("Call writev error, %s", strerror(errno));
		return -errno;
	}

	/* Set timeout */
	if (rtb_cfg.timerfd > 0)
		timeout_set(rtb_cfg.timerfd, msec);

	do {
		nfds = epoll_wait(rtb_cfg.epollfd, events, MAX_EVENTS, msec);
		if (nfds == -1) {
			RS_ERR("epoll_wait, %s (%d)", strerror(errno), errno);
			exit(EXIT_FAILURE);
		}

		for (n = 0; n < nfds; ++n) {
			if (events[n].data.fd == rtb_cfg.serial_fd) {
				if (events[n].events & (EPOLLERR | EPOLLHUP |
				    EPOLLRDHUP)) {
					RS_ERR("%s: Error happens on serial fd",
					       __func__);
					exit(EXIT_FAILURE);
				}
				result = read(events[n].data.fd, buf,
					      sizeof(buf));
				if (result <= 0) {
					RS_ERR("Read serial error, %s",
					       strerror(errno));
					continue;
				} else {
					h5_recv(&rtb_cfg, buf, result);
				}
			} else if (events[n].data.fd == rtb_cfg.timerfd) {
				if (events[n].events & (EPOLLERR | EPOLLHUP |
				    EPOLLRDHUP)) {
					RS_ERR("%s: Error happens on timer fd",
					       __func__);
					exit(EXIT_FAILURE);
				}
				RS_WARN("%s Transmission timeout",
					op_string(op));
				result = read(events[n].data.fd, &expired,
					      sizeof(expired));
				if (result != sizeof(expired)) {
					RS_ERR("Skip retransmit");
					break;
				}
				if (retry <= 0) {
					RS_ERR("Retransmission exhausts");
					tcflush(fd, TCIOFLUSH);
					exit(EXIT_FAILURE);
				}

				iov.iov_base = data;
				iov.iov_len = len;

				do {
					ret = writev(fd, &iov, 1);
					if (ret != len)
						RS_WARN("Writev partial, %d",
							(int)ret);
				} while (ret < 0 && errno == EINTR);

				if (ret < 0) {
					RS_ERR("ReCall writev error, %s",
					       strerror(errno));
					return -errno;
				}

				retry--;
				timeout_set(rtb_cfg.timerfd, msec);
			}
		}

		if (!(op & (1 << 24))) {
			/* h5 sync or config */
			if (op == OP_H5_SYNC && rtb_cfg.link_estab_state ==
			    H5_CONFIG) {
				op_result = 0;
				break;
			}

			if (op == OP_H5_CONFIG && rtb_cfg.link_estab_state ==
			    H5_INIT) {
				op_result = 0;
				break;
			}
			continue;
		}

		if (rtb_cfg.cmd_state.opcode == opcode &&
		    rtb_cfg.cmd_state.state == CMD_STATE_SUCCESS) {
			op_result = 0;
			break;
		}
	} while (1);

	/* Disarms timer */
	timeout_set(rtb_cfg.timerfd, 0);

	return op_result;
}

static int h5_download_patch(int dd, int index, uint8_t *data, int len,
			      struct termios *ti)
{
	unsigned char buf[64];
	int retlen;
	struct iovec iov;
	ssize_t ret;
	int nfds;
	struct epoll_event events[MAX_EVENTS];
	int n;
	int timeout;
	uint64_t expired;
	int retry = 3;
	struct sk_buff *nskb;
	uint8_t hci_patch[PATCH_DATA_FIELD_MAX_SIZE + 4];

	if (index & 0x80) {
		rtb_cfg.tx_index = index & 0x7f;
		timeout = 1000;
	} else {
		rtb_cfg.tx_index = index;
		timeout = 800;
	}

	/* download cmd: 0xfc20 */
	hci_patch[0] = 0x20;
	hci_patch[1] = 0xfc;
	hci_patch[2] = len + 1;
	hci_patch[3] = (uint8_t)index;
	if (data)
		memcpy(&hci_patch[4], data, len);

	/* length: 2-byte opcode + 1-byte len + 1-byte index + payload */
	nskb = h5_prepare_pkt(&rtb_cfg, hci_patch, len + 4, HCI_COMMAND_PKT);
	if (!nskb) {
		RS_ERR("Prepare command packet for download");
		return -1;
	}

	/* Save pkt address and length for re-transmission */
	len = nskb->data_len;
	data = nskb->data;

	iov.iov_base = nskb->data;
	iov.iov_len = nskb->data_len;
	do {
		ret = writev(dd, &iov, 1);
		if (ret != len)
			RS_WARN("Writev partially, ret %d", (int)ret);
	} while (ret < 0 && errno == EINTR);

	if (ret < 0) {
		RS_ERR("Call writev error, %s", strerror(errno));
		skb_free(nskb);
		return -errno;
	}

	/* RS_INFO("%s: tx_index %d, rx_index %d", __func__,
	 * 	rtb_cfg.tx_index, rtb_cfg.rx_index);
	 */

	if (index & 0x80) {
		/* For the last pkt, wait for its complete */
		tcdrain(dd);

		if (rtb_cfg.uart_flow_ctrl) {
			RS_INFO("Enable host hw flow control");
			ti->c_cflag |= CRTSCTS;
		} else {
			RS_INFO("Disable host hw flow control");
			ti->c_cflag &= ~CRTSCTS;
		}

		if (tcsetattr(dd, TCSANOW, ti) < 0) {
			RS_ERR("Can't set port settings");
			skb_free(nskb);
			return -1;
		}

		/* RS_INFO("Change baud to %d", rtb_cfg.final_speed);
		 * if (set_speed(dd, ti, rtb_cfg.final_speed) < 0) {
		 * 	RS_ERR("Set final speed %d error",
		 * 	       rtb_cfg.final_speed);
		 * }
		 */
	}

	if (rtb_cfg.timerfd > 0)
		timeout_set(rtb_cfg.timerfd, timeout);

	do {
		nfds = epoll_wait(rtb_cfg.epollfd, events, MAX_EVENTS, -1);
		if (nfds == -1) {
			RS_ERR("epoll_wait, %s (%d)", strerror(errno), errno);
			exit(EXIT_FAILURE);
		}

		for (n = 0; n < nfds; ++n) {
			if (events[n].data.fd == dd) {
				if (events[n].events & (EPOLLERR | EPOLLHUP |
				    EPOLLRDHUP)) {
					RS_ERR("%s: Error happens on serial fd",
					       __func__);
					exit(EXIT_FAILURE);
				}
				retlen = read(dd, buf, sizeof(buf));
				if (retlen <= 0) {
					RS_ERR("Read serial error, %s", strerror(errno));
					continue;
				} else {
					h5_recv(&rtb_cfg, buf, retlen);
				}
			} else if (events[n].data.fd == rtb_cfg.timerfd) {
				int fd = events[n].data.fd;

				if (events[n].events & (EPOLLERR | EPOLLHUP |
				    EPOLLRDHUP)) {
					RS_ERR("%s: Error happens on timer fd",
					       __func__);
					exit(EXIT_FAILURE);
				}
				RS_WARN("Patch pkt trans timeout, re-trans");
				ret = read(fd, &expired, sizeof(expired));
				if (ret != sizeof(expired)) {
					RS_ERR("Read expired info error");
					exit(EXIT_FAILURE);
				}
				if (retry <= 0) {
					RS_ERR("%s: Retransmission exhausts",
					       __func__);
					tcflush(fd, TCIOFLUSH);
					exit(EXIT_FAILURE);
				}

				iov.iov_base = data;
				iov.iov_len = len;

				do {
					ret = writev(dd, &iov, 1);
					if (ret != len)
						RS_WARN("Writev partial, %d",
							(int)ret);
				} while (ret < 0 && errno == EINTR);

				if (ret < 0) {
					RS_ERR("ReCall writev error, %s",
					       strerror(errno));
					skb_free(nskb);
					return -errno;
				}

				retry--;
				timeout_set(fd, timeout);
			}
		}
	} while (rtb_cfg.rx_index != rtb_cfg.tx_index);

	/* Disarms timer */
	if (rtb_cfg.timerfd > 0)
		timeout_set(rtb_cfg.timerfd, 0);

	skb_free(nskb);
	return 0;
}

/*
 * Change the Controller's UART speed.
 */
int h5_vendor_change_speed(int fd, uint32_t baudrate)
{
	struct sk_buff *nskb = NULL;
	unsigned char cmd[16] = { 0 };
	int result;

	cmd[0] = 0x17;
	cmd[1] = 0xfc;
	cmd[2] = 4;

	baudrate = cpu_to_le32(baudrate);
#ifdef BAUDRATE_4BYTES
	memcpy((uint16_t *) & cmd[3], &baudrate, 4);
#else
	memcpy((uint16_t *) & cmd[3], &baudrate, 2);

	cmd[5] = 0;
	cmd[6] = 0;
#endif

	RS_DBG("baudrate in change speed command: 0x%02x 0x%02x 0x%02x 0x%02x",
	       cmd[3], cmd[4], cmd[5], cmd[6]);

	nskb = h5_prepare_pkt(&rtb_cfg, cmd, 7, HCI_COMMAND_PKT);
	if (!nskb) {
		RS_ERR("Prepare command packet for change speed fail");
		return -1;
	}

	rtb_cfg.cmd_state.opcode = HCI_VENDOR_CHANGE_BAUD;;
	rtb_cfg.cmd_state.state = CMD_STATE_UNKNOWN;
	result = start_transmit_wait(fd, nskb, OP_SET_BAUD, 1000, 0);
	skb_free(nskb);
	if (result < 0) {
		RS_ERR("OP_SET_BAUD Transmission error");
		return result;
	}

	return 0;
}

/*
 * Init realtek Bluetooth h5 proto.
 * There are two steps: h5 sync and h5 config.
 */
int rtb_init_h5(int fd, struct termios *ti)
{
	struct sk_buff *nskb;
	unsigned char h5sync[2] = { 0x01, 0x7E };
	/* 16-bit CCITT CRC may be used and the sliding win size is 4 */
	unsigned char h5conf[3] = { 0x03, 0xFC, 0x14 };
	int result;

	/* Disable CRTSCTS by default */
	ti->c_cflag &= ~CRTSCTS;

	/* set even parity */
	ti->c_cflag |= PARENB;
	ti->c_cflag &= ~(PARODD);
	if (tcsetattr(fd, TCSANOW, ti) < 0) {
		RS_ERR("Can't set port settings");
		return -1;
	}

	/* h5 sync */
	rtb_cfg.link_estab_state = H5_SYNC;
	nskb = h5_prepare_pkt(&rtb_cfg, h5sync, sizeof(h5sync),
			      H5_LINK_CTL_PKT);
	result = start_transmit_wait(fd, nskb, OP_H5_SYNC, 500, 10);
	skb_free(nskb);
	if (result < 0) {
		RS_ERR("OP_H5_SYNC Transmission error");
		return -1;
	}

	/* h5 config */
	nskb = h5_prepare_pkt(&rtb_cfg, h5conf, sizeof(h5conf), H5_LINK_CTL_PKT);
	result = start_transmit_wait(fd, nskb, OP_H5_CONFIG, 500, 10);
	skb_free(nskb);
	if (result < 0) {
		RS_ERR("OP_H5_CONFIG Transmission error");
		return -1;
	}

	rtb_send_ack(fd);
	RS_DBG("H5 init finished\n");

	rtb_cfg.cmd_state.state = CMD_STATE_UNKNOWN;

	return 0;
}

static int h5_hci_reset(int fd)
{
	uint8_t cmd[3] = { 0x03, 0x0c, 0x00};
	struct sk_buff *nskb;
	int result;

	RS_INFO("%s: Issue hci reset cmd", __func__);

	nskb = h5_prepare_pkt(&rtb_cfg, cmd, sizeof(cmd), HCI_COMMAND_PKT);
	if (!nskb) {
		RS_ERR("%s: Failed to alloc mem for hci reset skb", __func__);
		return -1;
	}

	rtb_cfg.cmd_state.opcode = HCI_CMD_RESET;
	rtb_cfg.cmd_state.state = CMD_STATE_UNKNOWN;

	result = start_transmit_wait(fd, nskb, OP_HCI_RESET, 1500, 1);
	skb_free(nskb);
	if (result < 0)
		RS_ERR("hci reset failed");

	return result;
}

#ifdef SERIAL_NONBLOCK_READ
static int set_fd_nonblock(int fd)
{
	long arg;
	int old_fl;

	arg = fcntl(fd, F_GETFL);
	if (arg < 0)
		return -errno;

	/* Return if already nonblock */
	if (arg & O_NONBLOCK)
		return FD_NONBLOCK;
	old_fl = FD_BLOCK;

	arg |= O_NONBLOCK;
	if (fcntl(fd, F_SETFL, arg) < 0)
		return -errno;

	return old_fl;
}

static int set_fd_block(int fd)
{
	long arg;

	arg = fcntl(fd, F_GETFL);
	if (arg < 0)
		return -errno;

	/* Return if already block */
	if (!(arg & O_NONBLOCK))
		return 0;

	arg &= ~O_NONBLOCK;
	if (fcntl(fd, F_SETFL, arg) < 0)
		return -errno;

	return 0;
}
#endif

/*
 * Download Realtek Firmware and Config
 */
static int rtb_download_fwc(int fd, uint8_t *buf, int size, int proto,
			    struct termios *ti)
{
	uint8_t curr_idx = 0;
	uint8_t curr_len = 0;
	uint8_t lp_len = 0;
	uint8_t add_pkts = 0;
	uint16_t end_idx = 0;
	uint16_t total_idx = 0;
	uint16_t num;
	unsigned char *pkt_buf;
	uint16_t i, j;
	int result;
#ifdef SERIAL_NONBLOCK_READ
	int old_fl;
#endif

	end_idx = (uint16_t)((size - 1) / PATCH_DATA_FIELD_MAX_SIZE);
	lp_len = size % PATCH_DATA_FIELD_MAX_SIZE;

	num = rtb_cfg.num_of_cmd_sent;
	num += end_idx + 1;

	add_pkts = num % 8 ? (8 - num % 8) : 0;

#ifdef SERIAL_NONBLOCK_READ
	old_fl = set_fd_nonblock(fd);
	if (old_fl < 0) {
		RS_ERR("Set fd nonblock error, %s", strerror(errno));
	}
	if (old_fl == FD_BLOCK)
		RS_INFO("old fd state is block");
#endif

	/* Make sure the next seqno is zero after download patch and
	 * hci reset
	 */
	if (proto == HCI_UART_3WIRE) {
		if (add_pkts)
			add_pkts -= 1;
		else
			add_pkts += 7;
	} else
		add_pkts = 0; /* No additional packets need */

	total_idx = add_pkts + end_idx;
	rtb_cfg.total_num = total_idx;

	RS_INFO("end_idx: %u, lp_len: %u, additional pkts: %u\n", end_idx,
		lp_len, add_pkts);
	RS_INFO("Start downloading...");

	if (lp_len == 0)
		lp_len = PATCH_DATA_FIELD_MAX_SIZE;

	pkt_buf = buf;

	for (i = 0; i <= total_idx; i++) {
		/* Index will roll over when it reaches 0x80
		 * 0, 1, 2, 3, ..., 126, 127(7f), 1, 2, 3, ...
		 */
		if (i > 0x7f)
			j = (i & 0x7f) + 1;
		else
			j = i;

		if (i < end_idx) {
			curr_idx = j;
			curr_len = PATCH_DATA_FIELD_MAX_SIZE;
		} else if (i == end_idx) {
			/* Send last data packets */
			if (i == total_idx)
				curr_idx = j | 0x80;
			else
				curr_idx = j;
			curr_len = lp_len;
		} else if (i < total_idx) {
			/* Send additional packets */
			curr_idx = j;
			pkt_buf = NULL;
			curr_len = 0;
			RS_INFO("Send additional packet %u", curr_idx);
		} else {
			/* Send last packet */
			curr_idx = j | 0x80;
			pkt_buf = NULL;
			curr_len = 0;
			RS_INFO("Last packet %u", curr_idx);
		}

		if (curr_idx & 0x80)
			RS_INFO("Send last pkt");

		if (proto == HCI_UART_H4) {
			curr_idx = h4_download_patch(fd, curr_idx, pkt_buf,
						     curr_len);
			if (curr_idx != j && i != total_idx) {
				RS_ERR("Index mismatch %u, curr_idx %u", j,
				       curr_idx);
				return -1;
			}
		} else if (proto == HCI_UART_3WIRE) {
			if (h5_download_patch(fd, curr_idx, pkt_buf, curr_len,
					      ti) < 0)
				return -1;
		}

		if (curr_idx < end_idx) {
			pkt_buf += PATCH_DATA_FIELD_MAX_SIZE;
		}
	}

	/* Make hci reset after Controller applies the Firmware and Config */
	if (proto == HCI_UART_H4)
		result = h4_hci_reset(fd);
	else
		result = h5_hci_reset(fd);

	if (proto == HCI_UART_3WIRE) {
		/* Make sure the last pure ack is sent */
		tcdrain(fd);
	}

	if (result)
		return result;


#ifdef SERIAL_NONBLOCK_READ
	if (old_fl == FD_BLOCK)
		set_fd_block(fd);
#endif

	return 0;
}

#define ARRAY_SIZE(a)	(sizeof(a)/sizeof(a[0]) )
struct rtb_baud {
	uint32_t rtb_speed;
	int uart_speed;
};

#ifdef BAUDRATE_4BYTES
struct rtb_baud baudrates[] = {
#ifdef RTL_8703A_SUPPORT
	{0x00004003, 1500000}, /* for rtl8703as */
#endif
	{0x0252C014, 115200},
	{0x0252C00A, 230400},
	{0x05F75004, 921600},
	{0x00005004, 1000000},
	{0x04928002, 1500000},
	{0x01128002, 1500000},	//8761AT
	{0x00005002, 2000000},
	{0x0000B001, 2500000},
	{0x04928001, 3000000},
	{0x052A6001, 3500000},
	{0x00005001, 4000000},
};
#else
struct rtb_baud baudrates[] = {
	{0x701d, 115200}
	{0x6004, 921600},
	{0x4003, 1500000},
	{0x5002, 2000000},
	{0x8001, 3000000},
	{0x9001, 3000000},
	{0x7001, 3500000},
	{0x5001, 4000000},
};
#endif

static void vendor_speed_to_std(uint32_t rtb_speed, uint32_t *uart_speed)
{
	*uart_speed = 115200;

	unsigned int i;
	for (i = 0; i < ARRAY_SIZE(baudrates); i++) {
		if (baudrates[i].rtb_speed == rtb_speed) {
			*uart_speed = baudrates[i].uart_speed;
			return;
		}
	}
	return;
}

static inline void std_speed_to_vendor(int uart_speed, uint32_t *rtb_speed)
{
	*rtb_speed = 0x701D;

	unsigned int i;
	for (i = 0; i < ARRAY_SIZE(baudrates); i++) {
		if (baudrates[i].uart_speed == uart_speed) {
			*rtb_speed = baudrates[i].rtb_speed;
			return;
		}
	}

	return;
}

void rtb_read_chip_type(int dd)
{
	/* 0xB000A094 */
	unsigned char cmd_buff[] = {
		0x61, 0xfc, 0x05, 0x00, 0x94, 0xa0, 0x00, 0xb0
	};
	struct sk_buff *nskb;
	int result;

	nskb = h5_prepare_pkt(&rtb_cfg, cmd_buff, sizeof(cmd_buff),
			      HCI_COMMAND_PKT);
	if (!nskb) {
		RS_ERR("Alloc chip type cmd skb buff error");
		exit(EXIT_FAILURE);
	}

	rtb_cfg.cmd_state.opcode = HCI_VENDOR_READ_CHIP_TYPE;
	rtb_cfg.cmd_state.state = CMD_STATE_UNKNOWN;
	result = start_transmit_wait(dd, nskb, OP_CHIP_TYPE, 250, 3);
	skb_free(nskb);
	if (result < 0)
		RS_ERR("OP_CHIP_TYPE Transmission error");

	return;
}

/*
 * Read ECO version with vendor cmd 0xfc65
 */
void rtb_read_eversion(int dd)
{
	int result;
	unsigned char cmd_buf[3] = { 0x6d, 0xfc, 0x00 };
	struct sk_buff *nskb;

	nskb= h5_prepare_pkt(&rtb_cfg, cmd_buf, 3, HCI_COMMAND_PKT);
	if (!nskb) {
		RS_ERR("Alloc eversion cmd skb buff error");
		exit(EXIT_FAILURE);
	}

	rtb_cfg.cmd_state.opcode = HCI_VENDOR_READ_ROM_VER;
	rtb_cfg.cmd_state.state = CMD_STATE_UNKNOWN;
	result = start_transmit_wait(dd, nskb, OP_ROM_VER, 500, 3);
	skb_free(nskb);
	if (result < 0) {
		RS_ERR("OP_ROM_VER Transmit error");
	}

	return;
}

void rtb_read_local_version(int dd)
{
	int result;
	unsigned char cmd_buf[3] = { 0x01, 0x10, 0x00 };
	struct sk_buff *nskb;

	nskb = h5_prepare_pkt(&rtb_cfg, cmd_buf, 3, HCI_COMMAND_PKT);
	if (!nskb) {
		RS_ERR("Alloc local ver cmd skb buff error");
		exit(EXIT_FAILURE);
	}

	rtb_cfg.cmd_state.state = CMD_STATE_UNKNOWN;
	rtb_cfg.cmd_state.opcode = HCI_CMD_READ_LOCAL_VER;
	result = start_transmit_wait(dd, nskb, OP_LMP_VER, 500, 3);
	skb_free(nskb);
	if (result < 0) {
		RS_ERR("OP_LMP_VER Transmit error");
	}

	return;
}

/*
 * Config Realtek Bluetooth.
 * Config parameters are got from Realtek Config file and FW.
 *
 * speed is the init_speed in uart struct
 * Returns 0 on success
 */
static int rtb_config(int fd, int proto, int speed, struct termios *ti)
{
	int final_speed = 0;
	int ret = 0;
	int max_patch_size = 0;

	rtb_cfg.proto = proto;

	/* Read Local Version Information and RTK ROM version */
	if (proto == HCI_UART_3WIRE) {
		RS_INFO("Realtek H5 IC");
		rtb_read_local_version(fd);
		rtb_read_eversion(fd);
	} else {
		RS_INFO("Realtek H4 IC");

		/* The following set is for special requirement that enables
		 * flow control before initializing */
#ifdef RTL8723DSH4_UART_HWFLOWC
		ti->c_cflag &= ~PARENB;
		ti->c_cflag |= CRTSCTS;
		if (tcsetattr(fd, TCSANOW, ti) < 0) {
			RS_ERR("H4 Can't enable RTSCTS");
			return -1;
		}
		usleep(20 * 1000);
#endif
		h4_read_local_ver(fd);
		h4_vendor_read_rom_ver(fd);
		if (rtb_cfg.lmp_subver == ROM_LMP_8761btc) {
			/* 8761B Test Chip */
			rtb_cfg.chip_type = CHIP_8761BTC;
			rtb_cfg.uart_flow_ctrl = 1;
			/* TODO: Change to different uart baud */
			std_speed_to_vendor(1500000, &rtb_cfg.vendor_baud);
			goto change_baud;
		} else if (rtb_cfg.lmp_subver == ROM_LMP_8761a) {
			if (rtb_cfg.hci_rev == 0x000b) {
				/* 8761B Test Chip without download */
				rtb_cfg.chip_type = CHIP_8761BH4;
				/* rtb_cfg.uart_flow_ctrl = 1; */
				/* TODO: Change to different uart baud */
				/* std_speed_to_vendor(1500000, &rtb_cfg.vendor_baud);
				 * goto change_baud;
				 */
			} else if (rtb_cfg.hci_rev == 0x000a) {
				if (rtb_cfg.eversion == 3)
					rtb_cfg.chip_type = CHIP_8761ATF;
				else if (rtb_cfg.eversion == 2)
					rtb_cfg.chip_type = CHIP_8761AT;
				else
					rtb_cfg.chip_type = CHIP_UNKNOWN;
			}
		} else if (rtb_cfg.lmp_subver == ROM_LMP_8723b) {
			if (rtb_cfg.hci_ver == 0x08 &&
			    rtb_cfg.hci_rev == 0x000d) {
				rtb_cfg.chip_type = CHIP_8723DS;
			} else if (rtb_cfg.hci_ver == 0x06 &&
				 rtb_cfg.hci_rev == 0x000b) {
				rtb_cfg.chip_type = CHIP_8723BS;
			} else {
				RS_ERR("H4: unknown chip");
				return -1;
			}
		}

	}

	RS_INFO("LMP Subversion 0x%04x", rtb_cfg.lmp_subver);
	RS_INFO("EVersion %u", rtb_cfg.eversion);

	switch (rtb_cfg.lmp_subver) {
	case ROM_LMP_8723a:
		break;
	case ROM_LMP_8723b:
#ifdef RTL_8703A_SUPPORT
		/* Set chip type for matching fw/config entry */
		rtl->chip_type = CHIP_8703AS;
#endif
		break;
	case ROM_LMP_8821a:
		break;
	case ROM_LMP_8761a:
		break;
	case ROM_LMP_8703b:
		rtb_read_chip_type(fd);
		break;
	}

	rtb_cfg.patch_ent = get_patch_entry(&rtb_cfg);
	if (rtb_cfg.patch_ent) {
		RS_INFO("IC: %s", rtb_cfg.patch_ent->ic_name);
		RS_INFO("Firmware/config: %s, %s",
			rtb_cfg.patch_ent->patch_file,
			rtb_cfg.patch_ent->config_file);
	} else {
		RS_ERR("Can not find firmware/config entry");
		return -1;
	}

	rtb_cfg.config_buf = rtb_read_config(rtb_cfg.patch_ent->config_file,
					     &rtb_cfg.config_len,
					     rtb_cfg.patch_ent->chip_type);
	if (!rtb_cfg.config_buf) {
		RS_ERR("Read Config file error, use eFuse settings");
		rtb_cfg.config_len = 0;
	}

	rtb_cfg.fw_buf = rtb_read_firmware(&rtb_cfg, &rtb_cfg.fw_len);
	if (!rtb_cfg.fw_buf) {
		RS_ERR("Read Bluetooth firmware error");
		rtb_cfg.fw_len = 0;
		/* Free config buf */
		if (rtb_cfg.config_buf) {
			free(rtb_cfg.config_buf);
			rtb_cfg.config_buf = NULL;
			rtb_cfg.config_len = 0;
		}
		return -1;
	} else {
		rtb_cfg.total_buf = rtb_get_final_patch(fd, proto,
							&rtb_cfg.total_len);
		/* If the above function executes successfully, the Config and
		 * patch were copied to the total buf */

		/* Free config buf */
		if (rtb_cfg.config_buf) {
			free(rtb_cfg.config_buf);
			rtb_cfg.config_buf = NULL;
		}
		/* Free the fw buf */
		free(rtb_cfg.fw_buf);
		rtb_cfg.fw_buf = NULL;
		rtb_cfg.fw_len = 0;

		if (!rtb_cfg.total_buf) {
			RS_ERR("Failed to get the final patch");
			exit(EXIT_FAILURE);
		}
	}

	switch ((rtb_cfg.patch_ent)->chip_type) {
	case CHIP_8822BS:
		max_patch_size = 25 * 1024;
		break;
	case CHIP_8821CS:
	case CHIP_8723DS:
	case CHIP_8822CS:
	case CHIP_8761B:
		max_patch_size = 40 * 1024;
		break;
	default:
		max_patch_size = 24 * 1024;
		break;
	}

	if (rtb_cfg.total_len > max_patch_size) {
		RS_ERR("Total length of fwc is larger than allowed");
		goto buf_free;
	}

	RS_INFO("Total len %d for fwc", rtb_cfg.total_len);

	/* rtl8723ds h4 */
	if (rtb_cfg.chip_type == CHIP_8723DS &&
	    rtb_cfg.proto == HCI_UART_H4) {
		if (rtb_cfg.parenb) {
			/* set parity */
			ti->c_cflag |= PARENB;
			if (rtb_cfg.pareven)
				ti->c_cflag &= ~(PARODD);
			else
				ti->c_cflag |= PARODD;
			if (tcsetattr(fd, TCSANOW, ti) < 0) {
				RS_ERR("8723DSH4 Can't set parity");
				goto buf_free;
			}
		}
	}

change_baud:
	/* change baudrate if needed
	 * rtb_cfg.vendor_baud is a __u32/__u16 vendor-specific variable
	 * parsed from config file
	 * */
	if (rtb_cfg.vendor_baud == 0) {
		/* No baud setting in Config file */
		std_speed_to_vendor(speed, &rtb_cfg.vendor_baud);
		RS_INFO("No baud from Config file, set baudrate: %d, 0x%08x",
			speed, rtb_cfg.vendor_baud);
		goto start_download;
	} else
		vendor_speed_to_std(rtb_cfg.vendor_baud,
				    (uint32_t *)&(rtb_cfg.final_speed));

	if (rtb_cfg.final_speed == 115200) {
		RS_INFO("Final speed is %d, no baud change needs",
			rtb_cfg.final_speed);
		goto start_download;
	}

	if (proto == HCI_UART_3WIRE)
		h5_vendor_change_speed(fd, rtb_cfg.vendor_baud);
	else
		h4_vendor_change_speed(fd, rtb_cfg.vendor_baud);

	/* Make sure the ack for cmd complete event is transmitted */
	tcdrain(fd);
	usleep(50000); /* The same value as before */
	final_speed = rtb_cfg.final_speed ? rtb_cfg.final_speed : speed;
	RS_INFO("Final speed %d", final_speed);
	if (set_speed(fd, ti, final_speed) < 0) {
		RS_ERR("Can't set baud rate: %d, %d, %d", final_speed,
		       rtb_cfg.final_speed, speed);
		goto buf_free;
	}

start_download:
	/* For 8761B Test chip, no patch to download */
	if (rtb_cfg.chip_type == CHIP_8761BTC)
		goto done;

	if (rtb_cfg.total_len > 0 && rtb_cfg.dl_fw_flag) {
		rtb_cfg.link_estab_state = H5_PATCH;
		rtb_cfg.rx_index = -1;

		ret = rtb_download_fwc(fd, rtb_cfg.total_buf, rtb_cfg.total_len,
				       proto, ti);
		free(rtb_cfg.total_buf);
		if (ret < 0)
			return ret;
	}

done:

	RS_DBG("Init Process finished");
	return 0;

buf_free:
	free(rtb_cfg.total_buf);
	return -1;
}

int rtb_init(int fd, int proto, int speed, struct termios *ti)
{
	struct epoll_event ev;
	int result;

	RS_INFO("Realtek hciattach version %s \n", RTK_VERSION);

	memset(&rtb_cfg, 0, sizeof(rtb_cfg));
	rtb_cfg.serial_fd = fd;
	rtb_cfg.dl_fw_flag = 1;

	rtb_cfg.epollfd = epoll_create(64);
	if (rtb_cfg.epollfd == -1) {
		RS_ERR("epoll_create1, %s (%d)", strerror(errno), errno);
		exit(EXIT_FAILURE);
	}

	ev.events = EPOLLIN | EPOLLERR | EPOLLHUP | EPOLLRDHUP;
	ev.data.fd = fd;
	if (epoll_ctl(rtb_cfg.epollfd, EPOLL_CTL_ADD, fd, &ev) == -1) {
		RS_ERR("epoll_ctl: epoll ctl add, %s (%d)", strerror(errno),
		       errno);
		exit(EXIT_FAILURE);
	}

	rtb_cfg.timerfd = timerfd_create(CLOCK_MONOTONIC, 0);
	if (rtb_cfg.timerfd == -1) {
		RS_ERR("timerfd_create error, %s (%d)", strerror(errno), errno);
		return -1;
	}

	if (rtb_cfg.timerfd > 0) {
		ev.events = EPOLLIN | EPOLLERR | EPOLLHUP | EPOLLRDHUP;
		ev.data.fd = rtb_cfg.timerfd;
		if (epoll_ctl(rtb_cfg.epollfd, EPOLL_CTL_ADD,
			      rtb_cfg.timerfd, &ev) == -1) {
			RS_ERR("epoll_ctl: epoll ctl add, %s (%d)",
			       strerror(errno), errno);
			exit(EXIT_FAILURE);
		}
	}

	RS_INFO("Use epoll");

	if (proto == HCI_UART_3WIRE) {
		if (rtb_init_h5(fd, ti) < 0)
			return -1;;
	}

	result = rtb_config(fd, proto, speed, ti);

	epoll_ctl(rtb_cfg.epollfd, EPOLL_CTL_DEL, fd, NULL);
	epoll_ctl(rtb_cfg.epollfd, EPOLL_CTL_DEL, rtb_cfg.timerfd, NULL);
	close(rtb_cfg.timerfd);
	rtb_cfg.timerfd = -1;

	return result;
}

int rtb_post(int fd, int proto, struct termios *ti)
{
	/* No need to change baudrate */
	/* if (rtb_cfg.final_speed)
	 * 	return set_speed(fd, ti, rtb_cfg.final_speed);
	 */

	return 0;
}
