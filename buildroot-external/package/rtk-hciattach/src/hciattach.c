/*
 *
 *  BlueZ - Bluetooth protocol stack for Linux
 *
 *  Copyright (C) 2000-2001  Qualcomm Incorporated
 *  Copyright (C) 2002-2003  Maxim Krasnyansky <maxk@qualcomm.com>
 *  Copyright (C) 2002-2010  Marcel Holtmann <marcel@holtmann.org>
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

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#define _GNU_SOURCE
#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <syslog.h>
#include <termios.h>
#include <time.h>
#include <sys/time.h>
#include <sys/poll.h>
#include <sys/param.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/uio.h>
#include <sys/timerfd.h>

#include "hciattach.h"

#define RFKILL_NODE	"/sys/class/rfkill/rfkill0/state"

#ifdef NEED_PPOLL
#include "ppoll.h"
#endif

/* #define SCHED_ENABLE */

#ifdef SCHED_ENABLE
#include <sched.h>
#endif

struct uart_t {
	char *type;
	int  m_id;
	int  p_id;
	int  proto;
	int  init_speed;
	int  speed;
	int  flags;
	int  pm;
	char *bdaddr;
	int  (*init) (int fd, struct uart_t *u, struct termios *ti);
	int  (*post) (int fd, struct uart_t *u, struct termios *ti);
};

#define FLOW_CTL	0x0001
#define ENABLE_PM	1
#define DISABLE_PM	0

static volatile sig_atomic_t __io_canceled = 0;

static void sig_hup(int sig)
{
	RS_INFO("signal hup.");
}

static void sig_term(int sig)
{
	switch (sig) {
	case SIGINT:
		RS_INFO("signal int.");
		break;
	case SIGTERM:
		RS_INFO("signal term.");
		break;
	}
	__io_canceled = 1;
}

static void sig_alarm(int sig)
{
	RS_ERR("Initialization timed out.");
	exit(1);
}

static int uart_speed(int s)
{
	switch (s) {
	case 9600:
		return B9600;
	case 19200:
		return B19200;
	case 38400:
		return B38400;
	case 57600:
		return B57600;
	case 115200:
		return B115200;
	case 230400:
		return B230400;
	case 460800:
		return B460800;
	case 500000:
		return B500000;
	case 576000:
		return B576000;
	case 921600:
		return B921600;
	case 1000000:
		return B1000000;
	case 1152000:
		return B1152000;
	case 1500000:
		return B1500000;
	case 2000000:
		return B2000000;
#ifdef B2500000
	case 2500000:
		return B2500000;
#endif
#ifdef B3000000
	case 3000000:
		return B3000000;
#endif
#ifdef B3500000
	case 3500000:
		return B3500000;
#endif
#ifdef B4000000
	case 4000000:
		return B4000000;
#endif
	default:
		return B57600;
	}
}

int set_speed(int fd, struct termios *ti, int speed)
{
	if (cfsetospeed(ti, uart_speed(speed)) < 0)
		return -errno;

	if (cfsetispeed(ti, uart_speed(speed)) < 0)
		return -errno;

	if (tcsetattr(fd, TCSANOW, ti) < 0)
		return -errno;

	return 0;
}

static int realtek_init(int fd, struct uart_t *u, struct termios *ti)
{

	RS_INFO("Realtek Bluetooth init uart with init speed:%d, type:HCI UART %s",
		u->init_speed,
		(u->proto == HCI_UART_H4) ? "H4" : "H5");
	return rtb_init(fd, u->proto, u->speed, ti);
}

static int realtek_post(int fd, struct uart_t *u, struct termios *ti)
{
	RS_INFO("Realtek Bluetooth post process");
	return rtb_post(fd, u->proto, ti);
}

struct uart_t uart[] = {
	{ "any",     0x0000, 0x0000, HCI_UART_H4,   115200, 115200, FLOW_CTL, DISABLE_PM, NULL, NULL},

	/* Realtek Bluetooth H4 */
	{ "rtk_h4",  0x0000, 0x0000, HCI_UART_H4,  115200,  115200, 0, DISABLE_PM, NULL, realtek_init, realtek_post },

	/* Realtek Bluetooth H5 */
	{ "rtk_h5",  0x0000, 0x0000, HCI_UART_3WIRE, 115200,115200, 0, DISABLE_PM, NULL, realtek_init, realtek_post },

	{ NULL, 0 }
};

static struct uart_t * get_by_id(int m_id, int p_id)
{
	int i;
	for (i = 0; uart[i].type; i++) {
		if (uart[i].m_id == m_id && uart[i].p_id == p_id)
			return &uart[i];
	}
	return NULL;
}

static struct uart_t * get_by_type(char *type)
{
	int i;
	for (i = 0; uart[i].type; i++) {
		if (!strcmp(uart[i].type, type))
			return &uart[i];
	}
	return NULL;
}

/* Initialize UART driver */
static int init_uart(char *dev, struct uart_t *u, int send_break, int raw)
{
	struct termios ti;
	int fd, i;
	unsigned long flags = 0;

	if (raw)
		flags |= 1 << HCI_UART_RAW_DEVICE;

	fd = open(dev, O_RDWR | O_NOCTTY);
	if (fd < 0) {
		RS_ERR("Can't open serial port, %d, %s", errno,
		       strerror(errno));
		return -1;
	}

	tcflush(fd, TCIOFLUSH);

	if (tcgetattr(fd, &ti) < 0) {
		RS_ERR("Can't get port settings, %d, %s", errno,
		       strerror(errno));
		return -1;
	}

	cfmakeraw(&ti);

	ti.c_cflag |= CLOCAL;
	if (u->flags & FLOW_CTL)
		ti.c_cflag |= CRTSCTS;
	else
		ti.c_cflag &= ~CRTSCTS;

	if (tcsetattr(fd, TCSANOW, &ti) < 0) {
		RS_ERR("Can't set port settings, %d, %s", errno,
		       strerror(errno));
		return -1;
	}

	/* Set initial baudrate */
	if (set_speed(fd, &ti, u->init_speed) < 0) {
		RS_ERR("Can't set initial baud rate, %d, %s", errno,
		       strerror(errno));
		return -1;
	}

	tcflush(fd, TCIOFLUSH);

	if (send_break) {
		tcsendbreak(fd, 0);
		usleep(500000);
	}

	if (u->init && u->init(fd, u, &ti) < 0)
		return -1;

	tcflush(fd, TCIOFLUSH);

	/* Set actual baudrate
	 * There is no need to change baudrate after uart init
	 * */
	/* if (set_speed(fd, &ti, u->speed) < 0) {
	 * 	perror("Can't set baud rate");
	 * 	return -1;
	 * }
	 */

	/* Set TTY to N_HCI line discipline */
	i = N_HCI;
	if (ioctl(fd, TIOCSETD, &i) < 0) {
		RS_ERR("Can't set line discipline %d, %s", errno,
		       strerror(errno));
		return -1;
	}

	if (flags && ioctl(fd, HCIUARTSETFLAGS, flags) < 0) {
		RS_ERR("Can't set UART flags %d, %s", errno, strerror(errno));
		return -1;
	}

	if (ioctl(fd, HCIUARTSETPROTO, u->proto) < 0) {
		RS_ERR("Can't set device %d, %s", errno, strerror(errno));
		return -1;
	}

	if (u->post && u->post(fd, u, &ti) < 0)
		return -1;

	return fd;
}

static int reset_bluetooth(void)
{

	int fd;
	char state[2];
	int result;

	/* power off and power on BT */
	fd = open(RFKILL_NODE, O_RDWR);
	if (fd < 0) {
		RS_ERR("Cannot open %s, %d %s", RFKILL_NODE, errno,
				strerror(errno));
		return -1;
	}
	state[0] = '0';
	state[1] = '\0';
	result = write(fd, state, strlen(state) + 1);
	if (result != (strlen(state) + 1)) {
		RS_ERR("Cannot write 0 to rfkill state %d %s", errno,
				strerror(errno));
		close(fd);
		return -1;
	}

	usleep(500000);

	state[0] = '1';
	state[1] = '\0';
	result = write(fd, state, strlen(state) + 1);
	if (result != (strlen(state) + 1)) {
		RS_ERR("Cannot write 1 to rfkill state %d %s", errno,
				strerror(errno));
		close(fd);
		return -1;
	}

	usleep(500000);
	close(fd);

	return 0;
}

static void usage(void)
{
	RS_INFO("hciattach - HCI UART driver initialization utility");
	RS_INFO("Usage:");
	RS_INFO("\thciattach [-n] [-p] [-b] [-r] [-t timeout] [-s initial_speed] <tty> <type | id> [speed] [flow|noflow] [bdaddr]");
	RS_INFO("\thciattach -l");
}

int main(int argc, char *argv[])
{
	struct uart_t *u = NULL;
	int detach, printpid, raw, opt, i, n, ld, err;
	int to = 10;
	int init_speed = 0;
	int send_break = 0;
	pid_t pid;
	struct sigaction sa;
	struct pollfd p;
	sigset_t sigs;
	char dev[PATH_MAX];
#ifdef SCHED_ENABLE
	struct sched_param sched_par;
#endif

	detach = 1;
	printpid = 0;
	raw = 0;

	while ((opt=getopt(argc, argv, "bnpt:s:lr")) != EOF) {
		switch(opt) {
		case 'b':
			send_break = 1;
			break;

		case 'n':
			detach = 0;
			break;

		case 'p':
			printpid = 1;
			break;

		case 't':
			to = atoi(optarg);
			break;

		case 's':
			init_speed = atoi(optarg);
			break;

		case 'l':
			for (i = 0; uart[i].type; i++) {
				RS_INFO("%-10s0x%04x,0x%04x", uart[i].type,
							uart[i].m_id, uart[i].p_id);
			}
			exit(0);

		case 'r':
			raw = 1;
			break;

		default:
			usage();
			exit(1);
		}
	}

	n = argc - optind;
	if (n < 2) {
		usage();
		exit(1);
	}

	for (n = 0; optind < argc; n++, optind++) {
		char *opt;

		opt = argv[optind];

		switch(n) {
		case 0:
			dev[0] = 0;
			if (!strchr(opt, '/'))
				strcpy(dev, "/dev/");
			strcat(dev, opt);
			break;

		case 1:
			if (strchr(argv[optind], ',')) {
				int m_id, p_id;
				sscanf(argv[optind], "%x,%x", &m_id, &p_id);
				u = get_by_id(m_id, p_id);
			} else {
				u = get_by_type(opt);
			}

			if (!u) {
				RS_ERR("Unknown device type or id");
				exit(1);
			}

			break;

		case 2:
			u->speed = atoi(argv[optind]);
			break;

		case 3:
			if (!strcmp("flow", argv[optind]))
				u->flags |=  FLOW_CTL;
			else
				u->flags &= ~FLOW_CTL;
			break;

		case 4:
			if (!strcmp("sleep", argv[optind]))
				u->pm = ENABLE_PM;
			else
				u->pm = DISABLE_PM;
			break;

		case 5:
			u->bdaddr = argv[optind];
			break;
		}
	}

	if (!u) {
		RS_ERR("Unknown device type or id");
		exit(1);
	}

start:

#ifdef SCHED_ENABLE
	RS_INFO("Increase the priority of the process with set sched");
	memset(&sched_par, 0, sizeof(sched_par));
	sched_par.sched_priority = 99;
	err = sched_setscheduler(0, SCHED_FIFO, &sched_par);
	if (err == -1) {
		RS_ERR("Call sched_setscheduler error, %s",
			strerror(errno));
	}
/* #else
 * 	RS_INFO("Increase the priority of the process with nice");
 * 	err = nice(-20);
 * 	if (err == -1) {
 * 		RS_ERR("Call nice error, %s", strerror(errno));
 * 	}
 */
#endif

	/* If user specified a initial speed, use that instead of
	   the hardware's default */
	if (init_speed)
		u->init_speed = init_speed;

	memset(&sa, 0, sizeof(sa));
	sa.sa_flags   = SA_NOCLDSTOP;
	sa.sa_handler = sig_alarm;
	sigaction(SIGALRM, &sa, NULL);

	/* 10 seconds should be enough for initialization */
	alarm(to);

	n = init_uart(dev, u, send_break, raw);
	if (n < 0) {
		RS_ERR("Can't initialize device %d, %s", errno,
		       strerror(errno));
		exit(1);
	}

	RS_INFO("Device setup complete");

	alarm(0);

	memset(&sa, 0, sizeof(sa));
	sa.sa_flags   = SA_NOCLDSTOP;
	sa.sa_handler = SIG_IGN;
	sigaction(SIGCHLD, &sa, NULL);
	sigaction(SIGPIPE, &sa, NULL);

	sa.sa_handler = sig_term;
	sigaction(SIGTERM, &sa, NULL);
	sigaction(SIGINT,  &sa, NULL);

	sa.sa_handler = sig_hup;
	sigaction(SIGHUP, &sa, NULL);

	if (detach) {
		if ((pid = fork())) {
			if (printpid)
				RS_INFO("%d", pid);
			return 0;
		}

		for (i = 0; i < 20; i++)
			if (i != n)
				close(i);
	}

	p.fd = n;
	p.events = POLLERR | POLLHUP;

	sigfillset(&sigs);
	sigdelset(&sigs, SIGCHLD);
	sigdelset(&sigs, SIGPIPE);
	sigdelset(&sigs, SIGTERM);
	sigdelset(&sigs, SIGINT);
	sigdelset(&sigs, SIGHUP);

	while (!__io_canceled) {
		p.revents = 0;
		err = ppoll(&p, 1, NULL, &sigs);
		if (err < 0 && errno == EINTR) {
			RS_INFO("Got EINTR.");
			continue;
		} if (err)
			break;
	}

	RS_INFO("err %d, p->revents %04x", err, p.revents);

	/* Restore TTY line discipline */
	RS_INFO("Restore TTY line discipline");
	ld = N_TTY;
	if (ioctl(n, TIOCSETD, &ld) < 0) {
		RS_ERR("Can't restore line discipline %d, %s", errno,
		       strerror(errno));
		exit(1);
	}

	if (p.revents & (POLLERR | POLLHUP)) {
		RS_INFO("Recover...");
		reset_bluetooth();
		goto start;
	}

	return 0;
}

void util_hexdump(const uint8_t *buf, size_t len)
{
	static const char hexdigits[] = "0123456789abcdef";
	char str[16 * 3];
	size_t i;

	if (!buf || !len)
		return;

	for (i = 0; i < len; i++) {
		str[((i % 16) * 3)] = hexdigits[buf[i] >> 4];
		str[((i % 16) * 3) + 1] = hexdigits[buf[i] & 0xf];
		str[((i % 16) * 3) + 2] = ' ';
		if ((i + 1) % 16 == 0) {
			str[16 * 3 - 1] = '\0';
			RS_INFO("%s", str);
		}
	}

	if (i % 16 > 0) {
		str[(i % 16) * 3 - 1] = '\0';
		RS_INFO("%s", str);
	}
}

int timeout_set(int fd, unsigned int msec)
{
	struct itimerspec itimer;
	unsigned int sec = msec / 1000;

	memset(&itimer, 0, sizeof(itimer));
	itimer.it_interval.tv_sec = 0;
	itimer.it_interval.tv_nsec = 0;
	itimer.it_value.tv_sec = sec;
	itimer.it_value.tv_nsec = (msec - (sec * 1000)) * 1000 * 1000;

	return timerfd_settime(fd, 0, &itimer, NULL);
}

