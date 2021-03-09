/*
* eQ-3 char loopback driver for HomeMatic / HomeMatic IP dual stack implementations
*
* Copyright (c) 2015 by eQ-3 Entwicklung GmbH
* Author: Lars Reemts, lars.reemts@finalbit.de
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*
*/

#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/init.h>
#include <linux/console.h>
#include <linux/sysrq.h>
#include <linux/interrupt.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/wait.h>
#include <linux/poll.h>
#include <linux/device.h>
#include <linux/clk.h>
#include <linux/delay.h>
#include <linux/uaccess.h>
#include <linux/circ_buf.h>
#include <linux/cdev.h>
#include <linux/sched.h>
#include <asm/termbits.h>
#include <asm/termios.h>
#include <asm/ioctls.h>
#include <linux/version.h>

#define EQ3LOOP_NUMBER_OF_CHANNELS 4
#define EQ3LOOP_DRIVER_NAME "eq3loop"

/* Use 'L' as magic number */
#define EQ3LOOP_IOC_MAGIC  'L'

#define EQ3LOOP_IOCSCREATESLAVE _IOW(EQ3LOOP_IOC_MAGIC,  1, uint32_t)
#define EQ3LOOP_IOCGEVENTS _IOR(EQ3LOOP_IOC_MAGIC,  2, uint32_t)

#define EVENT_BIT_SLAVE_OPENED 0
#define EVENT_BIT_SLAVE_CLOSED 1
#define STATE_BIT_SLAVE_OPENED 15

#define CONNECTION_TYPE_MASTER 0
#define CONNECTION_TYPE_SLAVE 1

#define BUFSIZE 1024  //just use buffer size power of 2. otherwise the size and index calculation dosn't work

#define DUMP_READWRITE 0

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(5,0,0))
  #define _access_ok(__type, __addr, __size) access_ok(__addr, __size)
#else
  #define _access_ok(__type, __addr, __size) access_ok(__type, __addr, __size)
#endif

struct eq3loop_channel_data
{
	struct circ_buf master2slave_buf;
	struct circ_buf slave2master_buf;
	unsigned char _master2slave_buf[BUFSIZE];
	unsigned char _slave2master_buf[BUFSIZE];
	
	wait_queue_head_t master2slaveq;
	wait_queue_head_t slave2masterq;
	struct semaphore sem;                              //semaphore for accessing this struct. 
	volatile long unsigned int pending_events;
	volatile long unsigned int slave_open_count;
	volatile long unsigned int created;
	dev_t devnode;
	char name[32];
	struct termios termios;
};

struct eq3loop_control_data {
	dev_t devnode;
	struct cdev cdev;
	struct class * class;
	struct eq3loop_channel_data channels[EQ3LOOP_NUMBER_OF_CHANNELS];
	struct semaphore sem;                              //semaphore for accessing this struct. 
};

struct eq3loop_connection_data
{
	int connection_type;
	struct eq3loop_channel_data* channel;
	ssize_t (*read) (struct eq3loop_channel_data *, struct file *, char __user *, size_t, loff_t *);
	ssize_t (*write) (struct eq3loop_channel_data *, struct file *, const char __user *, size_t, loff_t *);    
	long (*ioctl) (struct eq3loop_channel_data *, struct file *, unsigned int cmd, unsigned long arg);
	int (*close) (struct eq3loop_channel_data *, struct file *);
	unsigned int (*poll) (struct eq3loop_channel_data *, struct file*, poll_table* wait);
};

static struct eq3loop_control_data* control_data;

static ssize_t eq3loop_read_slave(struct eq3loop_channel_data* channel, struct file *filp, char *buf, size_t count, loff_t *offset)
{
	ssize_t ret = 0;
	int count_to_end,tail;
	if (down_interruptible(&channel->sem)){
		return -ERESTARTSYS;
	}

	
	if( !channel->created )
	{
		ret = -ENODEV;
		goto out;
	}
	while( channel->created && !CIRC_CNT( channel->master2slave_buf.head, channel->master2slave_buf.tail, BUFSIZE)) { /* nothing to read */
		up(&channel->sem); /* release the lock */
		if (filp->f_flags & O_NONBLOCK)	{
			return -EAGAIN;
		}
		if (wait_event_interruptible(channel->master2slaveq, (!channel->created) || CIRC_CNT( channel->master2slave_buf.head, channel->master2slave_buf.tail, BUFSIZE))){
			return -ERESTARTSYS; /* signal: tell the fs layer to handle it */
		}
		/* otherwise loop, but first reacquire the lock */
		if (down_interruptible(&channel->sem)){
			return -ERESTARTSYS;
		}
	}
	
	if( !channel->created )
	{
		ret = -ENODEV;
		goto out;
	}
	tail = channel->master2slave_buf.tail;
	/* ok, data is there, return something */
	count = min((int)count, CIRC_CNT( channel->master2slave_buf.head, tail, BUFSIZE));
	count_to_end = min((int)count,CIRC_CNT_TO_END(channel->master2slave_buf.head,tail,BUFSIZE));
	
	#if DUMP_READWRITE
	{
		int i;
		printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_read_slave() %s:", channel->name );
		for( i=0; i<count; i++ )
		{
			printk( " %02X", channel->master2slave_buf.buf[(tail + i) & (BUFSIZE - 1)] );
		}
	}
	#endif
	
	
	if (copy_to_user(buf, channel->master2slave_buf.buf + tail, count_to_end)) {
		ret = -EFAULT;
		goto out;
	}
	tail = (tail + count_to_end) & (BUFSIZE - 1);

	if (copy_to_user(buf + count_to_end, channel->master2slave_buf.buf + tail, count - count_to_end)) {
		ret = -EFAULT;
		goto out;
	}
	tail = (tail + (count - count_to_end)) & (BUFSIZE - 1);
	smp_mb();
	channel->master2slave_buf.tail = tail;
	ret = count;
	
out:
	up (&channel->sem);

	if( ret > 0 )
	{
		wake_up_interruptible( &channel->master2slaveq );
	}
	else
	{
		printk( KERN_ERR EQ3LOOP_DRIVER_NAME ": eq3loop_read_slave() %s: error while reading from slave", channel->name );
	}
	return ret;
}

static ssize_t eq3loop_read_master(struct eq3loop_channel_data* channel, struct file *filp, char *buf, size_t count, loff_t *offset)
{
	ssize_t ret = 0;
	int count_to_end,tail;
	if (down_interruptible(&channel->sem))
		return -ERESTARTSYS;
	
	while( channel->slave_open_count && (!CIRC_CNT( channel->slave2master_buf.head, channel->slave2master_buf.tail, BUFSIZE))) { /* slave open but nothing to read */
		up(&channel->sem); /* release the lock */
		if (filp->f_flags & O_NONBLOCK)
			return -EAGAIN;
		if (wait_event_interruptible(channel->slave2masterq, (!channel->slave_open_count) || CIRC_CNT( channel->slave2master_buf.head, channel->slave2master_buf.tail, BUFSIZE)))
			return -ERESTARTSYS; /* signal: tell the fs layer to handle it */
		/* otherwise loop, but first reacquire the lock */
		if (down_interruptible(&channel->sem))
			return -ERESTARTSYS;
	}
	if( channel->slave_open_count )
	{
		tail = channel->slave2master_buf.tail;
		/* ok, data is there, return something */
		count = min((int)count, CIRC_CNT( channel->slave2master_buf.head, tail, BUFSIZE));
		count_to_end = min((int)count,CIRC_CNT_TO_END(channel->slave2master_buf.head, tail, BUFSIZE));
		
		#if DUMP_READWRITE
		{
			int i;
			printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_read_master() %s:", channel->name );
			for( i=0; i<count; i++ )
			{
				printk( " %02X", channel->slave2master_buf.buf[(tail + i) & (BUFSIZE - 1)] );
			}
		}
		#endif
		
		
		if (copy_to_user(buf, channel->slave2master_buf.buf + tail, count_to_end)) {
			ret = -EFAULT;
			goto out;
		}
		tail = (tail + count_to_end) & (BUFSIZE - 1);
		if (copy_to_user(buf + count_to_end, channel->slave2master_buf.buf + tail, count - count_to_end)) {
			ret = -EFAULT;
			goto out;
		}
		tail = (tail + (count - count_to_end)) & (BUFSIZE - 1);
		smp_mb();
		channel->slave2master_buf.tail = tail;
		ret = count;
	}
	
	
out:
	up (&channel->sem);
	
	if( ret > 0 )
	{
		wake_up_interruptible( &channel->slave2masterq );
	}

	return ret;
}

static ssize_t eq3loop_read(struct file *filp, char *buf, size_t count, loff_t *offset)
{
	struct eq3loop_connection_data *conn = filp->private_data;
	if( conn && conn->read )
	{
		return conn->read( conn->channel, filp, buf, count, offset );
	}
	return -EFAULT;
}

static ssize_t eq3loop_write_slave(struct eq3loop_channel_data* channel, struct file *filp, const char *buf, size_t count, loff_t *offset)
{
	int head;
	ssize_t ret=0;
        ssize_t count_to_end;
	if (down_interruptible(&channel->sem))
		return -ERESTARTSYS;

	while(!CIRC_SPACE( channel->slave2master_buf.head, channel->slave2master_buf.tail, BUFSIZE)) { /* no space to write */
		up(&channel->sem); /* release the lock */
		if (filp->f_flags & O_NONBLOCK)
			return -EAGAIN;
		if (wait_event_interruptible(channel->slave2masterq, (!channel->created) || CIRC_SPACE( channel->slave2master_buf.head, channel->slave2master_buf.tail, BUFSIZE)))
			return -ERESTARTSYS; /* signal: tell the fs layer to handle it */
		/* otherwise loop, but first reacquire the lock */
		if (down_interruptible(&channel->sem))
			return -ERESTARTSYS;
	}
	
	if( !channel->created )
	{
		ret = -ENODEV;
		goto out;
	}
	head = channel->slave2master_buf.head;
	if(CIRC_SPACE( head, channel->slave2master_buf.tail, BUFSIZE) < count)
	{
		ret=-EFAULT;
		goto out;
	}
	
	/* ok, space is free, write something */
	count_to_end = min((int)count, CIRC_SPACE_TO_END( head, channel->slave2master_buf.tail, BUFSIZE));
	
	if(copy_from_user(channel->slave2master_buf.buf + head, buf, count_to_end)){
		ret=-EFAULT;
		goto out;
	}
    head = (head + count_to_end) & (BUFSIZE - 1);

	if(copy_from_user(channel->slave2master_buf.buf + head, buf+count_to_end, count - count_to_end)){
		ret=-EFAULT;
		goto out;
	}
 	head = (head + (count - count_to_end)) & (BUFSIZE - 1);
	#if DUMP_READWRITE
	{
		int i;
        if(head < channel->slave2master_buf.head)
        {
        	printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_write_slave() reach end of circular buffer" );
        }
		printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_write_slave() %s:", channel->name );
		for( i=0; i<count; i++ )
		{
			printk( " %02X", channel->slave2master_buf.buf[(channel->slave2master_buf.head + i)& (BUFSIZE - 1)] );
		}
	}
	#endif
	
	
	smp_mb();
	channel->slave2master_buf.head = head;
	
	ret = count;
	
out:
	up (&channel->sem);

	if( ret > 0 )
	{
		wake_up_interruptible( &channel->slave2masterq );
	}
	
	return ret;
}

static ssize_t eq3loop_write_master(struct eq3loop_channel_data* channel, struct file *filp, const char *buf, size_t count, loff_t *offset)
{
	ssize_t ret=0;
	int head;
	ssize_t count_to_end;
	if (down_interruptible(&channel->sem))
		return -ERESTARTSYS;

	while(!CIRC_SPACE( channel->master2slave_buf.head, channel->master2slave_buf.tail, BUFSIZE)) { /* no space to write */
		up(&channel->sem); /* release the lock */
		if (filp->f_flags & O_NONBLOCK)
			return -EAGAIN;
		if (wait_event_interruptible(channel->master2slaveq, (!channel->slave_open_count) || CIRC_SPACE( channel->master2slave_buf.head, channel->master2slave_buf.tail, BUFSIZE)))
			return -ERESTARTSYS; /* signal: tell the fs layer to handle it */
		/* otherwise loop, but first reacquire the lock */
		if (down_interruptible(&channel->sem))
			return -ERESTARTSYS;
	}
	head = channel->master2slave_buf.head;
	if(CIRC_SPACE( head, channel->master2slave_buf.tail, BUFSIZE) < count)
	{
		ret=-EFAULT;
		count_to_end = CIRC_SPACE( head, channel->master2slave_buf.tail, BUFSIZE);
		printk( KERN_ERR EQ3LOOP_DRIVER_NAME ": eq3loop_write_master() %s: not enough space in buffers. free space = %zu, required space = %zu", channel->name,count_to_end,count );
		goto out;
	}
	/* ok, space is free, write something */
	count_to_end = min((int)count, CIRC_SPACE_TO_END( head, channel->master2slave_buf.tail, BUFSIZE));

	if(copy_from_user(channel->master2slave_buf.buf + head, buf, count_to_end)){
		ret=-EFAULT;
		printk( KERN_ERR EQ3LOOP_DRIVER_NAME ": eq3loop_write_master() %s: unable to copy buffer",channel->name );
		goto out;
	}
	head = (head + count_to_end) & (BUFSIZE - 1);
	if(copy_from_user(channel->master2slave_buf.buf + head, buf+count_to_end,count - count_to_end)){
		ret=-EFAULT;
		printk( KERN_ERR EQ3LOOP_DRIVER_NAME ": eq3loop_write_master() %s: unable to copy buffer",channel->name );
		goto out;
	}
	head = (head + (count - count_to_end)) & (BUFSIZE - 1);
	#if DUMP_READWRITE
	{
		int i;
		printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_write_master() %s:", channel->name );
		for( i=0; i<count; i++ )
		{
			printk( " %02X", channel->master2slave_buf.buf[(channel->master2slave_buf.head + i)&(BUFSIZE - 1)] );
		}
	}
	#endif
	smp_mb();
	channel->master2slave_buf.head = head;
	ret = count;

out:
	up (&channel->sem);
	if(ret < 0)
	{
		printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_write_master() return error: %d", ret);
	}
	if( ret > 0 || CIRC_CNT(channel->master2slave_buf.head,channel->master2slave_buf.tail,BUFSIZE) )
	{
		//send a signal to reading procces if return is ok or data in the buffer
		wake_up_interruptible( &channel->master2slaveq );
	}
	
	return ret;
}

static ssize_t eq3loop_write(struct file *filp, const char *buf, size_t count, loff_t *offset)
{
	struct eq3loop_connection_data *conn = filp->private_data;
	if( conn && conn->write )
	{
		return conn->write( conn->channel, filp, buf, count, offset );
	}
	return -EFAULT;
}

static long eq3loop_create_slave_dev( struct file *filp, const char* name );

static long eq3loop_ioctl_ctrl(struct file *filp, unsigned int cmd, unsigned long arg)
{
	char buffer[64];
	long ret = 0;
	
	/*
	* extract the type and number bitfields, and don't decode
	* wrong cmds: return ENOTTY (inappropriate ioctl) before access_ok()
	*/
	if (_IOC_TYPE(cmd) != EQ3LOOP_IOC_MAGIC) return -ENOTTY;


	switch(cmd) {

	case EQ3LOOP_IOCSCREATESLAVE:
		ret = strncpy_from_user( buffer, (char*)arg, sizeof(buffer) );
		if( ret <= 0 )
		{
			return -EFAULT;
		}
		return eq3loop_create_slave_dev( filp, buffer );
	default:
		return -ENOTTY;
	}
}

static long eq3loop_ioctl_master(struct eq3loop_channel_data* channel, struct file *filp, unsigned int cmd, unsigned long arg)
{
	long ret = 0;
	unsigned long temp = 0;
	
	/*
	* extract the type and number bitfields, and don't decode
	* wrong cmds: return ENOTTY (inappropriate ioctl) before access_ok()
	*/
	if (_IOC_TYPE(cmd) != EQ3LOOP_IOC_MAGIC) return -ENOTTY;

	/*
	* the direction is a bitmask, and VERIFY_WRITE catches R/W
	* transfers. `Type' is user-oriented, while
	* access_ok is kernel-oriented, so the concept of "read" and
	* "write" is reversed
	*/
	if (_IOC_DIR(cmd) & _IOC_READ)
	  ret = !_access_ok(VERIFY_WRITE, (void *)arg, _IOC_SIZE(cmd));
	else if (_IOC_DIR(cmd) & _IOC_WRITE)
	  ret =  !_access_ok(VERIFY_READ, (void *)arg, _IOC_SIZE(cmd));
	if (ret) return -EFAULT;

	switch(cmd) {

	case EQ3LOOP_IOCGEVENTS:
		if( test_and_clear_bit( EVENT_BIT_SLAVE_OPENED, &channel->pending_events ) )
		{
			temp |= (1<<EVENT_BIT_SLAVE_OPENED);
		}
		if( test_and_clear_bit( EVENT_BIT_SLAVE_CLOSED, &channel->pending_events ) )
		{
			temp |= (1<<EVENT_BIT_SLAVE_CLOSED);
		}
		if( test_bit( STATE_BIT_SLAVE_OPENED, &channel->pending_events ) )
		{
			temp |= (1<<STATE_BIT_SLAVE_OPENED);
		}
		ret = __put_user(temp, (unsigned long *)arg);
		if( ret )
		{
			channel->pending_events = temp;
			smp_mb();
		}
		break;
	default:
		return -ENOTTY;
	}
	return ret;
}

static long eq3loop_ioctl_slave(struct eq3loop_channel_data* channel, struct file *filp, unsigned int cmd, unsigned long arg)
{
	long ret = 0;
	int temp;
	
	if (down_interruptible(&channel->sem))
		return -ERESTARTSYS;
	
	switch(cmd) {

	case TCGETS:
		if( _access_ok(VERIFY_READ, (void *)arg, sizeof(struct termios) ) )
		{
			ret = copy_to_user( (void*)arg, &channel->termios, sizeof(struct termios) );
		} else {
			ret = -EFAULT;
		}
		break;
	case TCSETS:
		if( _access_ok(VERIFY_WRITE, (void *)arg, sizeof(struct termios) ) )
		{
			ret = copy_from_user( &channel->termios, (void*)arg, sizeof(struct termios) );
		} else {
			ret = -EFAULT;
		}
		break;
	case TIOCINQ:
		temp = CIRC_CNT( channel->master2slave_buf.head, channel->master2slave_buf.tail, BUFSIZE);
		ret = __put_user( temp, (int*)arg );
		break;
	case TIOCOUTQ:
		temp = CIRC_CNT( channel->slave2master_buf.head, channel->slave2master_buf.tail, BUFSIZE);
		ret = __put_user( temp, (int*)arg );
		break;
	case TIOCEXCL:
		break;
	case TCFLSH:
		break;
	case TIOCMGET:
		temp = TIOCM_DSR | TIOCM_CD | TIOCM_CTS;
		ret = __put_user( temp, (int*)arg );
		break;
	case TIOCMSET:
		break;
	case TIOCSERGETLSR:
		ret = -ENOIOCTLCMD;
		break;
	case TIOCGICOUNT:
		ret = -ENOIOCTLCMD;
		break;
	default:
		ret = -ENOTTY;
		break;
	}
	up (&channel->sem );
	if( ret == -ENOTTY )
	{
		printk( KERN_NOTICE EQ3LOOP_DRIVER_NAME ": eq3loop_ioctl_slave() %s: unhandled ioctl 0x%04X\n", channel->name, cmd );
		ret = -ENOIOCTLCMD;
	}
	return ret;
}

#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,11))
static int eq3loop_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
#else
static long eq3loop_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
#endif
{
	struct eq3loop_connection_data *conn = filp->private_data;
	if( !conn )
	{
		return eq3loop_ioctl_ctrl( filp, cmd, arg );
	}
	if( conn->ioctl )
	{
		return conn->ioctl( conn->channel, filp, cmd, arg );
	}
	
	return -EFAULT;   
}


static int eq3loop_close_slave(struct eq3loop_channel_data* channel, struct file *filp)
{
	int ret = 0;
	
	printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_close_slave() %s\n", channel->name );
	
	if (down_interruptible(&channel->sem))
	return -ERESTARTSYS;
	
	if( channel->slave_open_count )
	{
		channel->slave_open_count--;
	}
	
	kfree( filp->private_data );

	set_bit( EVENT_BIT_SLAVE_CLOSED, &channel->pending_events );
	clear_bit( STATE_BIT_SLAVE_OPENED, &channel->pending_events );

	if( !channel->created )
	{
		printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_close_slave() %s destroy device\n", channel->name );
		device_destroy(control_data->class, channel->devnode);
	}
	
	up( &channel->sem );
	smp_mb();
	wake_up_interruptible( &channel->slave2masterq );
	return ret;
}

static int eq3loop_close_master(struct eq3loop_channel_data* channel, struct file *filp)
{
	int ret = 0;
	
	printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_close_master() %s\n", channel->name );
	
	if (down_interruptible(&channel->sem))
	return -ERESTARTSYS;
	
	if (down_interruptible(&control_data->sem))
	{
		ret = -ERESTARTSYS;
		goto out;
	}
	
	channel->created = 0;

	up( &control_data->sem );
	
	kfree( filp->private_data );
	
	if( !channel->slave_open_count )
	{
		printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_close_master() %s destroy device\n", channel->name );
		device_destroy(control_data->class, channel->devnode);
	}
	
out:
	up( &channel->sem );
	wake_up_interruptible( &channel->master2slaveq );
	return ret;
}

static int eq3loop_close(struct inode *inode, struct file *filp)
{
	struct eq3loop_connection_data *conn = filp->private_data;
	if( !conn )
	{
		return 0;
	}
	if( conn->close )
	{
		return conn->close( conn->channel, filp );
	}
	
	return -ENODEV;   
}

static unsigned int eq3loop_poll_master(struct eq3loop_channel_data* channel, struct file* filp, poll_table* wait)
{
	unsigned int mask=0;
	unsigned long requested_events = poll_requested_events( wait );
	
	//printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_poll_master() %s requested=0x%lX\n", channel->name, requested_events );
	
	if( requested_events & ( POLLIN | POLLPRI | POLLERR ) )
	{
		poll_wait(filp, &channel->slave2masterq, wait);
	}
	if( requested_events & POLLOUT )
	{
		poll_wait(filp, &channel->master2slaveq, wait);
	}
	
	if (down_interruptible(&channel->sem))
	return -ERESTARTSYS;    
	
	if( channel->slave_open_count )
	{
		if( CIRC_SPACE( channel->master2slave_buf.head, channel->master2slave_buf.tail, BUFSIZE) )
		{
			mask |= POLLOUT | POLLWRNORM;
		}
		
		if( CIRC_CNT( channel->slave2master_buf.head, channel->slave2master_buf.tail, BUFSIZE) )
		{
			mask |= POLLIN | POLLRDNORM;
		}
	}
	
	if( test_bit( EVENT_BIT_SLAVE_OPENED, &channel->pending_events ) || test_bit( EVENT_BIT_SLAVE_CLOSED, &channel->pending_events ) )
	{
		mask |= POLLPRI;
	}
	
	
	
	up( &channel->sem );

	return mask;
}

static unsigned int eq3loop_poll_slave(struct eq3loop_channel_data* channel, struct file* filp, poll_table* wait)
{
	unsigned int mask=0;
	unsigned long requested_events = poll_requested_events( wait );
	
	if( requested_events & POLLIN )
	{
		poll_wait(filp, &channel->master2slaveq, wait);
	}
	if( requested_events & POLLOUT )
	{
		poll_wait(filp, &channel->slave2masterq, wait);
	}
	
	if (down_interruptible(&channel->sem))
	return -ERESTARTSYS;    
	
	if( CIRC_CNT( channel->master2slave_buf.head, channel->master2slave_buf.tail, BUFSIZE) )
	{
		mask |= POLLIN | POLLRDNORM;
	}
	
	if( CIRC_SPACE( channel->slave2master_buf.head, channel->slave2master_buf.tail, BUFSIZE) )
	{
		mask |= POLLOUT | POLLWRNORM;
	}
	
	if( !channel->created )
	{
		mask |= POLLERR;
	}
	
	up( &channel->sem );
	
	return mask;
}

static unsigned int eq3loop_poll(struct file* filp, poll_table* wait)
{
	struct eq3loop_connection_data *conn = filp->private_data;
	if( !conn )
	{
		return -EINVAL;
	}
	if( conn->poll )
	{
		return conn->poll( conn->channel, filp, wait );
	}
	
	return -EINVAL;
}


static long eq3loop_create_slave_dev( struct file *filp, const char* name )
{
	int channel_index = 0;
	long ret = 0;
	struct eq3loop_channel_data* channel;
	struct eq3loop_connection_data* conn;
	
	if (down_interruptible(&control_data->sem))
	return -ERESTARTSYS;
	
	while( (channel_index < EQ3LOOP_NUMBER_OF_CHANNELS) &&  (control_data->channels[channel_index].created) )
	{
		channel_index++;
	}
	if( channel_index >= EQ3LOOP_NUMBER_OF_CHANNELS )
	{
		ret = -EINVAL;
		goto out;
	}
	
	channel = control_data->channels + channel_index;
	memset( channel, 0, sizeof( struct eq3loop_channel_data ) );
	channel->devnode = MKDEV(MAJOR(control_data->devnode), MINOR(control_data->devnode) + channel_index + 1);
	strncpy( channel->name, name, sizeof(channel->name)-1 );
	
	if( !device_create(control_data->class, NULL, channel->devnode, "%s", name) )
	{
		ret = -EBUSY;
		goto out;
	}
	
	printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": created slave %s\n", name );

	conn = kzalloc( sizeof(struct eq3loop_connection_data), GFP_KERNEL );
	if( !conn )
	{
		ret = -ENOMEM;
		goto out;
	}
	
	sema_init(&channel->sem, 1);
	init_waitqueue_head(&channel->master2slaveq);
	init_waitqueue_head(&channel->slave2masterq);
	
	
	channel->master2slave_buf.buf = channel->_master2slave_buf;
	channel->slave2master_buf.buf = channel->_slave2master_buf;
	
	smp_mb();
	
	channel->created = 1;
	
	
out:
	up(&control_data->sem);
	
	if( !ret )
	{ 
		conn->connection_type = CONNECTION_TYPE_MASTER;
		conn->channel = channel;
		conn->read = eq3loop_read_master;
		conn->write = eq3loop_write_master;
		conn->ioctl = eq3loop_ioctl_master;
		conn->close = eq3loop_close_master;
		conn->poll = eq3loop_poll_master;
		filp->private_data = conn;
	}
	return ret;
}

static int eq3loop_open_ctrl(struct file *filp)
{
	return 0;
}

static int eq3loop_open_slave(struct eq3loop_channel_data* channel, struct file *filp)
{
	int ret = 0;
	struct eq3loop_connection_data* conn;
	
	printk( KERN_INFO EQ3LOOP_DRIVER_NAME ": eq3loop_open_slave() %s\n", channel->name );
	
	if (down_interruptible(&channel->sem))
	return -ERESTARTSYS;
	
	if( !channel->created )
	{
		ret = -ENODEV;
		goto out;
	}
	
	if( channel->slave_open_count )
	{
		ret = -EBUSY;
		goto out;
	}
	
	conn = kzalloc( sizeof(struct eq3loop_connection_data), GFP_KERNEL );
	if( !conn )
	{
		ret = -ENOMEM;
		goto out;
	}
	
	channel->slave_open_count++;
	
	set_bit( EVENT_BIT_SLAVE_OPENED, &channel->pending_events );
	set_bit( STATE_BIT_SLAVE_OPENED, &channel->pending_events );
	
	channel->master2slave_buf.head = 0;
	channel->master2slave_buf.tail = 0;
	
	smp_mb();
	
out:
	up( &channel->sem );
	
	if( !ret )
	{ 
		conn->connection_type = CONNECTION_TYPE_SLAVE;
		conn->channel = channel;
		conn->read = eq3loop_read_slave;
		conn->write = eq3loop_write_slave;
		conn->ioctl = eq3loop_ioctl_slave;
		conn->close = eq3loop_close_slave;
		conn->poll = eq3loop_poll_slave;
		filp->private_data = conn;
		wake_up_interruptible( &channel->slave2masterq );
	}
	return ret;
}


static int eq3loop_open(struct inode *inode, struct file *filp)
{
	if( !control_data )
	{
		return -ENODEV;
	}
	
	if( inode->i_rdev == MKDEV(MAJOR(control_data->devnode), MINOR(control_data->devnode)) )
	{
		return eq3loop_open_ctrl( filp );
	}else{
		unsigned int channel_index = MINOR( inode->i_rdev ) - MINOR(control_data->devnode) - 1;
		if( channel_index >= EQ3LOOP_NUMBER_OF_CHANNELS )
		{
			return -ENODEV;
		}
		return eq3loop_open_slave( &control_data->channels[channel_index], filp );
	}
	
	return -ENODEV;
}

static struct file_operations eq3loop_fops = {
	.owner		= THIS_MODULE,
	.llseek		= no_llseek,
	.read		= eq3loop_read,
	.write		= eq3loop_write,
	.open		= eq3loop_open,
	.release	= eq3loop_close,
	.poll       = eq3loop_poll,
#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,11))
	.ioctl      = eq3loop_ioctl,
#else
	.unlocked_ioctl = eq3loop_ioctl,
	.compat_ioctl = eq3loop_ioctl,
#endif
};

static int __init eq3loop_init(void)
{
	int ret = 0;

	control_data = kzalloc(sizeof(struct eq3loop_control_data), GFP_KERNEL);
	if (!control_data) {
		ret = -ENOMEM;
		goto out;
	}

	ret = alloc_chrdev_region(&control_data->devnode, 0, EQ3LOOP_NUMBER_OF_CHANNELS + 1, EQ3LOOP_DRIVER_NAME);
	if( ret )
	{
		printk(KERN_ERR EQ3LOOP_DRIVER_NAME ": Unable to get device number region\n");
		goto out_free;
	}
	
	cdev_init(&control_data->cdev, &eq3loop_fops);
	control_data->cdev.owner=THIS_MODULE;
	control_data->cdev.ops=&eq3loop_fops;
	ret=cdev_add(&control_data->cdev, control_data->devnode, EQ3LOOP_NUMBER_OF_CHANNELS + 1);
	if(ret){
		printk(KERN_ERR EQ3LOOP_DRIVER_NAME ": Unable to add driver\n");
		goto out_unregister_chrdev_region;
	}
	control_data->class=class_create(THIS_MODULE, EQ3LOOP_DRIVER_NAME);
	if(IS_ERR(control_data->class)){
		ret = -EIO;
		printk(KERN_ERR EQ3LOOP_DRIVER_NAME ": Unable to register driver class\n");
		goto out_cdev_del;
	}
	
	sema_init(&control_data->sem, 1);
	
	device_create(control_data->class, NULL, MKDEV(MAJOR(control_data->devnode), MINOR(control_data->devnode)), "%s", EQ3LOOP_DRIVER_NAME);
	
	goto out;
	
	out_cdev_del:
	cdev_del(&control_data->cdev);
	
	out_unregister_chrdev_region:
	unregister_chrdev_region(control_data->devnode, EQ3LOOP_NUMBER_OF_CHANNELS + 1);
	
	out_free:
	kfree(control_data);
out:
	return ret;
}

static void __exit eq3loop_exit(void)
{

	unregister_chrdev_region(control_data->devnode, EQ3LOOP_NUMBER_OF_CHANNELS + 1);
	device_destroy(control_data->class, MKDEV(MAJOR(control_data->devnode), MINOR(control_data->devnode)));
	class_destroy(control_data->class);
	cdev_del(&control_data->cdev);
	
	kfree(control_data);
	
	control_data = NULL;

}

module_init(eq3loop_init);
module_exit(eq3loop_exit);
MODULE_DESCRIPTION("eQ-3 IPC loopback char driver");
MODULE_LICENSE("GPL");
MODULE_VERSION("1.1");
