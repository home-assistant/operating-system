/*
 *
 *  BlueZ - Bluetooth protocol stack for Linux
 *
 *  Copyright (C) 2003-2009  Marcel Holtmann <marcel@holtmann.org>
 *
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
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

#include <termios.h>
#include <stdint.h>
#include <syslog.h>

#if __BYTE_ORDER == __LITTLE_ENDIAN
#define cpu_to_le16(d)  (d)
#define cpu_to_le32(d)  (d)
#define le16_to_cpu(d)  (d)
#define le32_to_cpu(d)  (d)
#elif __BYTE_ORDER == __BIG_ENDIAN
#define cpu_to_le16(d)  bswap_16(d)
#define cpu_to_le32(d)  bswap_32(d)
#define le16_to_cpu(d)  bswap_16(d)
#define le32_to_cpu(d)  bswap_32(d)
#else
#error "Unknown byte order"
#endif

#ifndef N_HCI
#define N_HCI	15
#endif

#define HCIUARTSETPROTO		_IOW('U', 200, int)
#define HCIUARTGETPROTO		_IOR('U', 201, int)
#define HCIUARTGETDEVICE	_IOR('U', 202, int)
#define HCIUARTSETFLAGS		_IOW('U', 203, int)
#define HCIUARTGETFLAGS		_IOR('U', 204, int)

#define HCI_UART_H4	0
#define HCI_UART_BCSP	1
#define HCI_UART_3WIRE	2
#define HCI_UART_H4DS	3
#define HCI_UART_LL	4
#define HCI_UART_RAW_DEVICE	0

extern uint8_t DBG_ON;

/* #define SYSLOG */

#define LOG_STR     "Realtek Bluetooth"
#ifdef SYSLOG
#define RS_DBG(fmt, arg...) \
    do{ \
        if (DBG_ON) \
            syslog(LOG_DEBUG, "%s :" fmt "\n" , LOG_STR, ##arg); \
    }while(0)

#define RS_INFO(fmt, arg...) \
    do{ \
        syslog(LOG_INFO, "%s :" fmt "\n", LOG_STR, ##arg); \
    }while(0)

#define RS_WARN(fmt, arg...) \
    do{ \
        syslog(LOG_WARNING, "%s WARN: " fmt "\n", LOG_STR, ##arg); \
    }while(0)

#define RS_ERR(fmt, arg...) \
    do{ \
        syslog(LOG_ERR, "%s ERROR: " fmt "\n", LOG_STR, ##arg); \
    }while(0)
#else
#define RS_DBG(fmt, arg...) \
    do{ \
        if (DBG_ON) \
            printf("%s :" fmt "\n" , LOG_STR, ##arg); \
    }while(0)

#define RS_INFO(fmt, arg...) \
    do{ \
        printf("%s :" fmt "\n", LOG_STR, ##arg); \
    }while(0)

#define RS_WARN(fmt, arg...) \
    do{ \
        printf("%s WARN: " fmt "\n", LOG_STR, ##arg); \
    }while(0)

#define RS_ERR(fmt, arg...) \
    do{ \
        printf("%s ERROR: " fmt "\n", LOG_STR, ##arg); \
    }while(0)
#endif

typedef enum _H5_RX_STATE {
	H5_W4_PKT_DELIMITER,
	H5_W4_PKT_START,
	H5_W4_HDR,
	H5_W4_DATA,
	H5_W4_CRC
} H5_RX_STATE;

typedef enum _H5_RX_ESC_STATE {
	H5_ESCSTATE_NOESC,
	H5_ESCSTATE_ESC
} H5_RX_ESC_STATE;

typedef enum _H5_LINK_STATE {
	H5_SYNC,
	H5_CONFIG,
	H5_INIT,
	H5_PATCH,
	H5_HCI_RESET,
	H5_ACTIVE
} H5_LINK_STATE;

struct patch_info;
typedef struct rtb_struct {
	/* three wire releated */
	uint8_t rxseq_txack;	/* expected rx seq number */
	uint8_t rxack;		/* last packet that the peer ack'ed */
	uint8_t use_crc;
	uint8_t is_txack_req;	/* txack required */
	uint8_t msgq_txseq;	/* next pkt seq */
	uint16_t message_crc;
	uint32_t rx_count;	/* expected pkts to recv */

	H5_RX_STATE rx_state;
	H5_RX_ESC_STATE rx_esc_state;
	H5_LINK_STATE link_estab_state;

	struct sk_buff *rx_skb;

	uint16_t num_of_cmd_sent;
	uint16_t lmp_subver;
	uint16_t hci_rev;
	uint8_t hci_ver;
	uint8_t eversion;
	uint8_t chip_type;

	uint32_t vendor_baud;
	uint8_t dl_fw_flag;
	int serial_fd;
	uint32_t uart_flow_ctrl;
	uint32_t parenb:   16;
	uint32_t pareven: 16;
	int final_speed;
	int total_num;	/* total pkt number */
	int tx_index;	/* current sending pkt number */
	int rx_index;	/* ack index from board */
	int fw_len;	/* fw patch file len */
	int config_len;	/* config patch file len */
	int total_len;	/* fw & config extracted buf len */
	uint8_t *fw_buf;	/* fw patch file buf */
	uint8_t *config_buf;	/* config patch file buf */
	uint8_t *total_buf;	/* fw & config extracted buf */
#define CMD_STATE_UNKNOWN	0x00
#define CMD_STATE_SUCCESS	0x01
	struct __cmd_state {
		uint16_t opcode;
		uint16_t state;
	} cmd_state;

	struct patch_info *patch_ent;

	int proto;
	int timerfd;
	int epollfd;
} rtb_struct_t;
extern struct rtb_struct rtb_cfg;
int timeout_set(int fd, unsigned int msec);
int set_speed(int fd, struct termios *ti, int speed);
int rtb_init(int fd, int proto, int speed, struct termios *ti);
int rtb_post(int fd, int proto, struct termios *ti);
void util_hexdump(const uint8_t *buf, size_t len);
