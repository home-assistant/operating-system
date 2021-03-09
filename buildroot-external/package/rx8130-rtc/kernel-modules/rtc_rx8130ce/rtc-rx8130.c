//======================================================================
// Driver for the Epson RTC module RX-8130 CE
//
// Copyright(C) SEIKO EPSON CORPORATION 2014. All rights reserved.
//
// Derived from RX-8025 driver:
// Copyright (C) 2009 Wolfgang Grandegger <wg@grandegger.com>
//
// Copyright (C) 2005 by Digi International Inc.
// All rights reserved.
//
// Modified by fengjh at rising.com.cn
// <http://lists.lm-sensors.org/mailman/listinfo/lm-sensors>
// 2006.11
//
// Code cleanup by Sergei Poselenov, <sposelenov@emcraft.com>
// Converted to new style by Wolfgang Grandegger <wg@grandegger.com>
// Alarm and periodic interrupt added by Dmitry Rakhchev <rda@emcraft.com>
// Support to enable Capacitor loading using device tree added by Alexander Reinert <alex@areinert.de>
//
//
// This driver software is distributed as is, without any warranty of any kind,
// either express or implied as further specified in the GNU Public License. This
// software may be used and distributed according to the terms of the GNU Public
// License, version 2 as published by the Free Software Foundation.
// See the file COPYING in the main directory of this archive for more details.
//
// You should have received a copy of the GNU General Public License along with
// this program. If not, see <http://www.gnu.org/licenses/>.
//======================================================================

#include <linux/device.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/init.h>
#include <linux/bcd.h>
#include <linux/i2c.h>
#include <linux/list.h>
#include <linux/rtc.h>
#include <linux/of_gpio.h>

#include <linux/of.h>
#include <linux/of_device.h>
#include <linux/of_irq.h>
#include <linux/interrupt.h>
#include <linux/input.h>

// RX-8130 Register definitions
#define RX8130_REG_SEC 0x10
#define RX8130_REG_MIN 0x11
#define RX8130_REG_HOUR 0x12
#define RX8130_REG_WDAY 0x13
#define RX8130_REG_MDAY 0x14
#define RX8130_REG_MONTH 0x15
#define RX8130_REG_YEAR 0x16

#define RX8130_REG_ALMIN 0x17
#define RX8130_REG_ALHOUR 0x18
#define RX8130_REG_ALWDAY 0x19
#define RX8130_REG_TCOUNT0 0x1A
#define RX8130_REG_TCOUNT1 0x1B
#define RX8130_REG_EXT 0x1C
#define RX8130_REG_FLAG 0x1D
#define RX8130_REG_CTRL0 0x1E
#define RX8130_REG_CTRL1 0x1F

#define RX8130_REG_END 0x23

// Extension Register (1Ch) bit positions
#define RX8130_BIT_EXT_TSEL (7 << 0)
#define RX8130_BIT_EXT_WADA (1 << 3)
#define RX8130_BIT_EXT_TE (1 << 4)
#define RX8130_BIT_EXT_USEL (1 << 5)
#define RX8130_BIT_EXT_FSEL (3 << 6)

// Flag Register (1Dh) bit positions
#define RX8130_BIT_FLAG_VLF (1 << 1)
#define RX8130_BIT_FLAG_AF (1 << 3)
#define RX8130_BIT_FLAG_TF (1 << 4)
#define RX8130_BIT_FLAG_UF (1 << 5)

// Control 0 Register (1Еh) bit positions
#define RX8130_BIT_CTRL_TSTP (1 << 2)
#define RX8130_BIT_CTRL_AIE (1 << 3)
#define RX8130_BIT_CTRL_TIE (1 << 4)
#define RX8130_BIT_CTRL_UIE (1 << 5)
#define RX8130_BIT_CTRL_STOP (1 << 6)
#define RX8130_BIT_CTRL_TEST (1 << 7)

// Control 1 Register (1Fh) bit positions
#define RX8130_BIT_CTRL_BFVSEL0 (1 << 0)
#define RX8130_BIT_CTRL_BFVSEL1 (1 << 1)
#define RX8130_BIT_CTRL_RSVSEL (1 << 2)
#define RX8130_BIT_CTRL_INIEN (1 << 4)
#define RX8130_BIT_CTRL_CHGEN (1 << 5)
#define RX8130_BIT_CTRL_SMPTSEL0 (1 << 6)
#define RX8130_BIT_CTRL_SMPTSEL1 (1 << 7)

static const struct i2c_device_id rx8130_id[] = {
	{"rx8130", 0},
	{"rx8130-legacy", 0},
	{}};
MODULE_DEVICE_TABLE(i2c, rx8130_id);

static const struct of_device_id rx8130_of_match[] = {
	{
		.compatible = "epson,rx8130-legacy",
	},
	{}};
MODULE_DEVICE_TABLE(of, rx8130_of_match);

struct rx8130_data
{
	struct i2c_client *client;
	struct rtc_device *rtc;
	struct work_struct work;
	u8 ctrlreg;
	unsigned exiting : 1;
	bool enable_external_capacitor;
};

typedef struct
{
	u8 number;
	u8 value;
} reg_data;

#define SE_RTC_REG_READ _IOWR('p', 0x20, reg_data)
#define SE_RTC_REG_WRITE _IOW('p', 0x21, reg_data)

//----------------------------------------------------------------------
// rx8130_read_reg()
// reads a rx8130 register (see Register defines)
// See also rx8130_read_regs() to read multiple registers.
//
//----------------------------------------------------------------------
static int rx8130_read_reg(struct i2c_client *client, int number, u8 *value)
{
	int ret = i2c_smbus_read_byte_data(client, number);

	//check for error
	if (ret < 0)
	{
		dev_err(&client->dev, "Unable to read register #%d\n", number);
		return ret;
	}

	*value = ret;
	return 0;
}

//----------------------------------------------------------------------
// rx8130_read_regs()
// reads a specified number of rx8130 registers (see Register defines)
// See also rx8130_read_reg() to read single register.
//
//----------------------------------------------------------------------
static int rx8130_read_regs(struct i2c_client *client, int number, u8 length, u8 *values)
{
	int ret = i2c_smbus_read_i2c_block_data(client, number, length, values);

	//check for length error
	if (ret != length)
	{
		dev_err(&client->dev, "Unable to read registers #%d..#%d\n", number, number + length - 1);
		return ret < 0 ? ret : -EIO;
	}

	return 0;
}

//----------------------------------------------------------------------
// rx8130_write_reg()
// writes a rx8130 register (see Register defines)
// See also rx8130_write_regs() to write multiple registers.
//
//----------------------------------------------------------------------
static int rx8130_write_reg(struct i2c_client *client, int number, u8 value)
{
	int ret = i2c_smbus_write_byte_data(client, number, value);

	//check for error
	if (ret)
		dev_err(&client->dev, "Unable to write register #%d\n", number);

	return ret;
}

//----------------------------------------------------------------------
// rx8130_write_regs()
// writes a specified number of rx8130 registers (see Register defines)
// See also rx8130_write_reg() to write a single register.
//
//----------------------------------------------------------------------
static int rx8130_write_regs(struct i2c_client *client, int number, u8 length, u8 *values)
{
	int ret = i2c_smbus_write_i2c_block_data(client, number, length, values);

	//check for error
	if (ret)
		dev_err(&client->dev, "Unable to write registers #%d..#%d\n", number, number + length - 1);

	return ret;
}

//----------------------------------------------------------------------
// rx8130_irq()
// irq handler
//
//----------------------------------------------------------------------
static irqreturn_t rx8130_irq(int irq, void *dev_id)
{
	struct i2c_client *client = dev_id;
	struct rx8130_data *rx8130 = i2c_get_clientdata(client);

	disable_irq_nosync(irq);
	schedule_work(&rx8130->work);

	return IRQ_HANDLED;
}

//----------------------------------------------------------------------
// rx8130_work()
//
//----------------------------------------------------------------------
static void rx8130_work(struct work_struct *work)
{
	struct rx8130_data *rx8130 = container_of(work, struct rx8130_data, work);
	struct i2c_client *client = rx8130->client;
	struct mutex *lock = &rx8130->rtc->ops_lock;
	u8 status;

	mutex_lock(lock);

	if (rx8130_read_reg(client, RX8130_REG_FLAG, &status))
		goto out;

	// check VLF
	if ((status & RX8130_BIT_FLAG_VLF))
		dev_warn(&client->dev, "Frequency stop was detected, probably due to a supply voltage drop\n");

	dev_dbg(&client->dev, "%s: RX8130_REG_FLAG: %xh\n", __func__, status);

	// periodic "fixed-cycle" timer
	if (status & RX8130_BIT_FLAG_TF)
	{
		status &= ~RX8130_BIT_FLAG_TF;
		local_irq_disable();
		rtc_update_irq(rx8130->rtc, 1, RTC_PF | RTC_IRQF);
		local_irq_enable();
	}

	// alarm function
	if (status & RX8130_BIT_FLAG_AF)
	{
		status &= ~RX8130_BIT_FLAG_AF;
		local_irq_disable();
		rtc_update_irq(rx8130->rtc, 1, RTC_AF | RTC_IRQF);
		local_irq_enable();
	}

	// time update function
	if (status & RX8130_BIT_FLAG_UF)
	{
		status &= ~RX8130_BIT_FLAG_UF;
		local_irq_disable();
		rtc_update_irq(rx8130->rtc, 1, RTC_UF | RTC_IRQF);
		local_irq_enable();
	}

	// acknowledge IRQ
	rx8130_write_reg(client, RX8130_REG_FLAG, status); //clear flags

out:
	if (!rx8130->exiting)
		enable_irq(client->irq);

	mutex_unlock(lock);
}

//----------------------------------------------------------------------
// rx8130_get_time()
// gets the current time from the rx8130 registers
//
//----------------------------------------------------------------------
static int rx8130_get_time(struct device *dev, struct rtc_time *dt)
{
	struct rx8130_data *rx8130 = dev_get_drvdata(dev);
	u8 date[7];
	int err;

	err = rx8130_read_regs(rx8130->client, RX8130_REG_SEC, 7, date);
	if (err)
		return err;

	dev_dbg(dev, "%s: read 0x%02x 0x%02x "
				 "0x%02x 0x%02x 0x%02x 0x%02x 0x%02x\n",
			__func__,
			date[0], date[1], date[2], date[3], date[4], date[5], date[6]);

	//Note: need to subtract 0x10 for index as register offset starts at 0x10
	dt->tm_sec = bcd2bin(date[RX8130_REG_SEC - 0x10] & 0x7f);
	dt->tm_min = bcd2bin(date[RX8130_REG_MIN - 0x10] & 0x7f);
	dt->tm_hour = bcd2bin(date[RX8130_REG_HOUR - 0x10] & 0x3f); //only 24-hour clock
	dt->tm_mday = bcd2bin(date[RX8130_REG_MDAY - 0x10] & 0x3f);
	dt->tm_mon = bcd2bin(date[RX8130_REG_MONTH - 0x10] & 0x1f) - 1;
	dt->tm_year = bcd2bin(date[RX8130_REG_YEAR - 0x10]);
	dt->tm_wday = bcd2bin(date[RX8130_REG_WDAY - 0x10] & 0x7f);

	if (dt->tm_year < 70)
		dt->tm_year += 100;

	dev_dbg(dev, "%s: date %ds %dm %dh %dmd %dm %dy\n", __func__,
			dt->tm_sec, dt->tm_min, dt->tm_hour,
			dt->tm_mday, dt->tm_mon, dt->tm_year);

	return rtc_valid_tm(dt);
}

//----------------------------------------------------------------------
// rx8130_set_time()
// Sets the current time in the rx8130 registers
//
// Note: If STOP is not set/cleared, the clock will start when the seconds
//       register is written
//
//----------------------------------------------------------------------
static int rx8130_set_time(struct device *dev, struct rtc_time *dt)
{
	struct rx8130_data *rx8130 = dev_get_drvdata(dev);
	u8 date[7];
	u8 ctrl;
	int ret;

	//set STOP bit before changing clock/calendar
	rx8130_read_reg(rx8130->client, RX8130_REG_CTRL0, &ctrl);
	rx8130->ctrlreg = ctrl | RX8130_BIT_CTRL_STOP;
	rx8130_write_reg(rx8130->client, RX8130_REG_CTRL0, rx8130->ctrlreg);

	dev_dbg(dev, "%s: date %ds %dm %dh %dmd %dm %dy\n", __func__,
			dt->tm_sec, dt->tm_min, dt->tm_hour,
			dt->tm_mday, dt->tm_mon, dt->tm_year);

	//Note: need to subtract 0x10 for index as register offset starts at 0x10
	date[RX8130_REG_SEC - 0x10] = bin2bcd(dt->tm_sec);
	date[RX8130_REG_MIN - 0x10] = bin2bcd(dt->tm_min);
	date[RX8130_REG_HOUR - 0x10] = bin2bcd(dt->tm_hour); //only 24hr time

	date[RX8130_REG_MDAY - 0x10] = bin2bcd(dt->tm_mday);
	date[RX8130_REG_MONTH - 0x10] = bin2bcd(dt->tm_mon + 1);
	date[RX8130_REG_YEAR - 0x10] = bin2bcd(dt->tm_year % 100);
	date[RX8130_REG_WDAY - 0x10] = bin2bcd(dt->tm_wday);

	dev_dbg(dev, "%s: write 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x\n",
			__func__, date[0], date[1], date[2], date[3], date[4], date[5], date[6]);

	ret = rx8130_write_regs(rx8130->client, RX8130_REG_SEC, 7, date);

	//clear STOP bit after changing clock/calendar
	rx8130_read_reg(rx8130->client, RX8130_REG_CTRL0, &ctrl);
	rx8130->ctrlreg = ctrl & ~RX8130_BIT_CTRL_STOP;
	rx8130_write_reg(rx8130->client, RX8130_REG_CTRL0, rx8130->ctrlreg);

	return ret;
}

//----------------------------------------------------------------------
// rx8130_init_client()
// initializes the rx8130
//
//----------------------------------------------------------------------
static int rx8130_init_client(struct i2c_client *client, int *need_reset)
{
	struct rx8130_data *rx8130 = i2c_get_clientdata(client);
	u8 ctrl[3];
	int need_clear = 0;
	int err;

	//get current extension, flag, control register values
	dev_dbg(&client->dev, "Trying to read RX8130_REG_EXT\n");
	err = rx8130_read_regs(rx8130->client, RX8130_REG_EXT, 3, ctrl);
	if (err)
		goto out;

	//set extension register, TE to 0, FSEL1-0 and TSEL2-0 for desired frequency
	ctrl[0] &= ~RX8130_BIT_EXT_TE;	 //set TE to 0
	ctrl[0] &= ~RX8130_BIT_EXT_FSEL; //set to 0 (off) for this case
	ctrl[0] |= 0x02;				 //set TSEL for 1Hz
	err = rx8130_write_reg(client, RX8130_REG_EXT, ctrl[0]);
	if (err)
		goto out;

	//clear "test bit"
	rx8130->ctrlreg = (ctrl[2] & ~RX8130_BIT_CTRL_TEST);

	if (rx8130->enable_external_capacitor)
	{
		// enable charging of external capacitor
		dev_info(&client->dev, "Enabling charging of external capacitor\n");
		ctrl[2] |= RX8130_BIT_CTRL_CHGEN;
		ctrl[2] |= RX8130_BIT_CTRL_INIEN;
		ctrl[2] |= RX8130_BIT_CTRL_BFVSEL0;
		err = rx8130_write_reg(client, RX8130_REG_CTRL1, ctrl[2]);
		if (err)
			goto out;
	}

	//check for VLF Flag (set at power-on)
	if ((ctrl[1] & RX8130_BIT_FLAG_VLF))
	{
		dev_warn(&client->dev, "Frequency stop was detected, probably due to a supply voltage drop\n");
		*need_reset = 1;
	}

	//check for Alarm Flag
	if (ctrl[1] & RX8130_BIT_FLAG_AF)
	{
		dev_warn(&client->dev, "Alarm was detected\n");
		need_clear = 1;
	}

	//check for Periodic Timer Flag
	if (ctrl[1] & RX8130_BIT_FLAG_TF)
	{
		dev_warn(&client->dev, "Periodic timer was detected\n");
		need_clear = 1;
	}

	//check for Update Timer Flag
	if (ctrl[1] & RX8130_BIT_FLAG_UF)
	{
		dev_warn(&client->dev, "Update timer was detected\n");
		need_clear = 1;
	}

	//reset or clear needed?
	if (*need_reset || need_clear)
	{
		//clear flag register
		err = rx8130_write_reg(client, RX8130_REG_FLAG, 0x00);
		if (err)
			goto out;

		//clear ctrl register
		err = rx8130_write_reg(client, RX8130_REG_CTRL0, 0x00);
		if (err)
			goto out;
	}
out:
	return err;
}

//----------------------------------------------------------------------
// rx8130_read_alarm()
// reads current Alarm
//----------------------------------------------------------------------
static int rx8130_read_alarm(struct device *dev, struct rtc_wkalrm *t)
{
	struct rx8130_data *rx8130 = dev_get_drvdata(dev);
	struct i2c_client *client = rx8130->client;
	u8 alarmvals[3]; //minute, hour, week/day values
	u8 ctrl[3];		 //extension, flag, control values
	int err;

	if (client->irq <= 0)
		return -EINVAL;

	//get current minute, hour, week/day alarm values
	err = rx8130_read_regs(client, RX8130_REG_ALMIN, 3, alarmvals);
	if (err)
		return err;
	dev_dbg(dev, "%s: minutes:0x%02x hours:0x%02x week/day:0x%02x\n",
			__func__, alarmvals[0], alarmvals[1], alarmvals[2]);

	//get current extension, flag, control register values
	err = rx8130_read_regs(client, RX8130_REG_EXT, 3, ctrl);
	if (err)
		return err;
	dev_dbg(dev, "%s: extension:0x%02x flag:0x%02x control:0x%02x \n",
			__func__, ctrl[0], ctrl[1], ctrl[2]);

	// Hardware alarm precision is 1 minute
	t->time.tm_sec = 0;
	t->time.tm_min = bcd2bin(alarmvals[0] & 0x7f);	//0x7f filters AE bit currently
	t->time.tm_hour = bcd2bin(alarmvals[1] & 0x3f); //0x3f filters AE bit currently, also 24hr only

	t->time.tm_wday = -1;
	t->time.tm_mday = -1;
	t->time.tm_mon = -1;
	t->time.tm_year = -1;

	dev_dbg(dev, "%s: date: %ds %dm %dh %dmd %dm %dy\n",
			__func__,
			t->time.tm_sec, t->time.tm_min, t->time.tm_hour,
			t->time.tm_mday, t->time.tm_mon, t->time.tm_year);

	t->enabled = !!(rx8130->ctrlreg & RX8130_BIT_CTRL_AIE);	   //check if interrupt is enabled
	t->pending = (ctrl[1] & RX8130_BIT_FLAG_AF) && t->enabled; //check if flag is triggered

	return err;
}

//----------------------------------------------------------------------
// rx8130_set_alarm()
// sets Alarm
//----------------------------------------------------------------------
static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
{
	struct i2c_client *client = to_i2c_client(dev);
	struct rx8130_data *rx8130 = dev_get_drvdata(dev);
	u8 alarmvals[3]; //minute, hour, day
	u8 extreg;		 //extension register
	u8 flagreg;		 //flag register
	int err;

	if (client->irq <= 0)
		return -EINVAL;

	//get current extension register
	err = rx8130_read_reg(client, RX8130_REG_EXT, &extreg);
	if (err < 0)
		return err;

	//get current flag register
	err = rx8130_read_reg(client, RX8130_REG_FLAG, &flagreg);
	if (err < 0)
		return err;

	// Hardware alarm precision is 1 minute
	alarmvals[0] = bin2bcd(t->time.tm_min);
	alarmvals[1] = bin2bcd(t->time.tm_hour);
	alarmvals[2] = bin2bcd(t->time.tm_mday);
	dev_dbg(dev, "%s: write 0x%02x 0x%02x 0x%02x\n", __func__, alarmvals[0], alarmvals[1], alarmvals[2]);

	//check interrupt enable and disable
	if (rx8130->ctrlreg & (RX8130_BIT_CTRL_AIE | RX8130_BIT_CTRL_UIE))
	{
		rx8130->ctrlreg &= ~(RX8130_BIT_CTRL_AIE | RX8130_BIT_CTRL_UIE);
		err = rx8130_write_reg(rx8130->client, RX8130_REG_CTRL0, rx8130->ctrlreg);
		if (err)
			return err;
	}

	//write the new minute and hour values
	//Note:assume minute and hour values will be enabled. Bit 7 of each of the
	//     minute, hour, week/day register can be set which will "disable" the
	//     register from triggering an alarm. See the RX8130 spec for more information
	err = rx8130_write_regs(rx8130->client, RX8130_REG_ALMIN, 2, alarmvals);
	if (err)
		return err;

	//set Week/Day bit
	// Week setting is typically not used, so we will assume "day" setting
	extreg |= RX8130_BIT_EXT_WADA; //set to "day of month"
	err = rx8130_write_reg(rx8130->client, RX8130_REG_EXT, extreg);
	if (err)
		return err;

	//set Day of Month register
	if (alarmvals[2] == 0)
	{
		alarmvals[2] |= 0x80; //turn on AE bit to ignore day of month (no zero day)
		err = rx8130_write_reg(rx8130->client, RX8130_REG_ALWDAY, alarmvals[2]);
	}
	else
	{
		err = rx8130_write_reg(rx8130->client, RX8130_REG_ALWDAY, alarmvals[2]);
	}
	if (err)
		return err;

	//clear Alarm Flag
	flagreg &= ~(RX8130_BIT_FLAG_AF | RX8130_BIT_FLAG_UF);
	err = rx8130_write_reg(rx8130->client, RX8130_REG_FLAG, flagreg);
	if (err)
		return err;

	//re-enable interrupt if required
	if (t->enabled)
	{

		if (rx8130->rtc->uie_rtctimer.enabled)
			rx8130->ctrlreg |= RX8130_BIT_CTRL_UIE; //set update interrupt enable
		if (rx8130->rtc->aie_timer.enabled)
			rx8130->ctrlreg |= (RX8130_BIT_CTRL_AIE | RX8130_BIT_CTRL_UIE); //set alarm interrupt enable

		err = rx8130_write_reg(rx8130->client, RX8130_REG_CTRL0, rx8130->ctrlreg);
		if (err)
			return err;
	}

	return 0;
}

//----------------------------------------------------------------------
// rx8130_alarm_irq_enable()
// sets enables Alarm IRQ
//----------------------------------------------------------------------
static int rx8130_alarm_irq_enable(struct device *dev, unsigned int enabled)
{
	struct i2c_client *client = to_i2c_client(dev);
	struct rx8130_data *rx8130 = dev_get_drvdata(dev);
	u8 flagreg;
	u8 ctrl;
	int err;

	//get the current ctrl settings
	ctrl = rx8130->ctrlreg;

	if (enabled)
	{
		if (rx8130->rtc->uie_rtctimer.enabled)
			ctrl |= RX8130_BIT_CTRL_UIE; //set update interrupt enable
		if (rx8130->rtc->aie_timer.enabled)
			ctrl |= (RX8130_BIT_CTRL_AIE | RX8130_BIT_CTRL_UIE); //set alarm interrupt enable
	}
	else
	{
		if (!rx8130->rtc->uie_rtctimer.enabled)
			ctrl &= ~RX8130_BIT_CTRL_UIE; //clear update interrupt enable
		if (!rx8130->rtc->aie_timer.enabled)
		{
			if (rx8130->rtc->uie_rtctimer.enabled)
				ctrl &= ~RX8130_BIT_CTRL_AIE;
			else
				ctrl &= ~(RX8130_BIT_CTRL_AIE | RX8130_BIT_CTRL_UIE); //clear alarm interrupt enable
		}
	}

	//clear alarm flag
	err = rx8130_read_reg(client, RX8130_REG_FLAG, &flagreg);
	if (err < 0)
		return err;
	flagreg &= ~RX8130_BIT_FLAG_AF;
	err = rx8130_write_reg(rx8130->client, RX8130_REG_FLAG, flagreg);
	if (err)
		return err;

	//update the Control register if the setting changed
	if (ctrl != rx8130->ctrlreg)
	{
		rx8130->ctrlreg = ctrl;
		err = rx8130_write_reg(rx8130->client, RX8130_REG_CTRL0, rx8130->ctrlreg);
		if (err)
			return err;
	}

	return 0;
}

//---------------------------------------------------------------------------
// rx8130_ioctl()
//
//---------------------------------------------------------------------------
static int rx8130_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
{
	struct i2c_client *client = to_i2c_client(dev);
	//struct rx8130_data *rx8130 = dev_get_drvdata(dev);
	//struct mutex *lock = &rx8130->rtc->ops_lock;
	int ret = 0;
	int tmp;
	void __user *argp = (void __user *)arg;
	reg_data reg;

	dev_dbg(dev, "%s: cmd=%x\n", __func__, cmd);

	switch (cmd)
	{
	case SE_RTC_REG_READ:
		if (copy_from_user(&reg, argp, sizeof(reg)))
			return -EFAULT;
		if (reg.number < RX8130_REG_SEC || reg.number > RX8130_REG_END)
			return -EFAULT;
		//mutex_lock(lock);
		ret = rx8130_read_reg(client, reg.number, &reg.value);
		//mutex_unlock(lock);
		if (!ret)
			return copy_to_user(argp, &reg, sizeof(reg)) ? -EFAULT : 0;
		break;

	case SE_RTC_REG_WRITE:
		if (copy_from_user(&reg, argp, sizeof(reg)))
			return -EFAULT;
		if (reg.number < RX8130_REG_SEC || reg.number > RX8130_REG_END)
			return -EFAULT;
		//mutex_lock(lock);
		ret = rx8130_write_reg(client, reg.number, reg.value);
		//mutex_unlock(lock);
		break;

	case RTC_VL_READ:
		//mutex_lock(lock);
		ret = rx8130_read_reg(client, RX8130_REG_FLAG, &reg.value);
		//mutex_unlock(lock);
		if (!ret)
		{
			tmp = !!(reg.value & RX8130_BIT_FLAG_VLF);
			return copy_to_user(argp, &tmp, sizeof(tmp)) ? -EFAULT : 0;
		}
		break;

	case RTC_VL_CLR:
		//mutex_lock(lock);
		ret = rx8130_read_reg(client, RX8130_REG_FLAG, &reg.value);
		if (!ret)
		{
			reg.value &= ~RX8130_BIT_FLAG_VLF;
			ret = rx8130_write_reg(client, RX8130_REG_FLAG, reg.value);
		}
		//mutex_unlock(lock);
		break;

	default:
		return -ENOIOCTLCMD;
	}

	return ret;
}

static struct rtc_class_ops rx8130_rtc_ops = {
	.read_time = rx8130_get_time,
	.set_time = rx8130_set_time,
	.read_alarm = rx8130_read_alarm,
	.set_alarm = rx8130_set_alarm,
	.alarm_irq_enable = rx8130_alarm_irq_enable,
	.ioctl = rx8130_ioctl,
};

//----------------------------------------------------------------------
// rx8130_probe()
// probe routine for the rx8130 driver
//
// Todo: - maybe change kzalloc to use devm_kzalloc
//       -
//----------------------------------------------------------------------
static int rx8130_probe(struct i2c_client *client, const struct i2c_device_id *id)
{
	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
	struct rx8130_data *rx8130;
	int err, need_reset = 0;

	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_I2C_BLOCK))
	{
		dev_err(&adapter->dev, "doesn't support required functionality\n");
		err = -EIO;
		goto errout;
	}

	rx8130 = kzalloc(sizeof(*rx8130), GFP_KERNEL);
	if (!rx8130)
	{
		dev_err(&adapter->dev, "failed to alloc memory\n");
		err = -ENOMEM;
		goto errout;
	}

	rx8130->client = client;
	i2c_set_clientdata(client, rx8130);
	INIT_WORK(&rx8130->work, rx8130_work);

#ifdef CONFIG_OF
	rx8130->enable_external_capacitor = of_property_read_bool(client->dev.of_node, "enable-external-capacitor");
#endif

	err = rx8130_init_client(client, &need_reset);
	if (err)
		goto errout_free;

	if (need_reset)
	{
		struct rtc_time tm;
		dev_info(&client->dev, "bad conditions detected, resetting date\n");
		rtc_time64_to_tm(0, &tm); // set to 1970/1/1

		rx8130_set_time(&client->dev, &tm);
	}

	rx8130->rtc = devm_rtc_device_register(&client->dev, client->name, &rx8130_rtc_ops, THIS_MODULE);

	if (IS_ERR(rx8130->rtc))
	{
		err = PTR_ERR(rx8130->rtc);
		dev_err(&client->dev, "unable to register the class device\n");
		goto errout_free;
	}

	if (client->irq > 0)
	{
		dev_info(&client->dev, "IRQ %d supplied\n", client->irq);
		err = devm_request_threaded_irq(&client->dev, client->irq, NULL, rx8130_irq, IRQF_TRIGGER_LOW | IRQF_ONESHOT, "rx8130", client);

		if (err)
		{
			dev_err(&client->dev, "unable to request IRQ\n");
			goto errout_reg;
		}
	}

	rx8130->rtc->irq_freq = 1;
	rx8130->rtc->max_user_freq = 1;

	return 0;

errout_reg:
errout_free:
	kfree(rx8130);

errout:
	dev_err(&adapter->dev, "probing for rx8130 failed\n");
	return err;
}

//----------------------------------------------------------------------
// rx8130_remove()
// remove routine for the rx8130 driver
//
// Todo: - maybe change kzalloc to devm_kzalloc
//       -
//----------------------------------------------------------------------
static int rx8130_remove(struct i2c_client *client)
{
	struct rx8130_data *rx8130 = i2c_get_clientdata(client);
	struct mutex *lock = &rx8130->rtc->ops_lock;

	if (client->irq > 0)
	{
		mutex_lock(lock);
		rx8130->exiting = 1;
		mutex_unlock(lock);

		free_irq(client->irq, client);
		cancel_work_sync(&rx8130->work);
	}

	kfree(rx8130);
	return 0;
}

static struct i2c_driver rx8130_driver = {
	.driver = {
		.name = "rtc-rx8130",
		.of_match_table = of_match_ptr(rx8130_of_match),
		.owner = THIS_MODULE,
	},
	.probe = rx8130_probe,
	.remove = rx8130_remove,
	.id_table = rx8130_id,
};

module_i2c_driver(rx8130_driver);

MODULE_AUTHOR("Val Krutov <vkrutov@eea.epson.com>");
MODULE_DESCRIPTION("RX8130CE RTC driver");
MODULE_LICENSE("GPL");
MODULE_VERSION("1.5");
