################################################################################
#
# lpc32xxcdl
#
################################################################################

LPC32XXCDL_VERSION = 2.11
LPC32XXCDL_SOURCE = lpc32xx_cdl-v$(LPC32XXCDL_VERSION).zip
LPC32XXCDL_SITE = https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/lpcware-archive/61/2

LPC32XXCDL_INSTALL_TARGET = NO
LPC32XXCDL_INSTALL_IMAGES = YES

ifeq ($(BR2_TARGET_LPC32XXCDL_BOARDNAME),"ea3250")
LPC32XXCDL_KICKSTART = kickstart/nand
LPC32XXCDL_KICKSTART_BURNER = nand/kickstart
LPC32XXCDL_S1L = s1l
LPC32XXCDL_S1L_BURNER = nand/s1lapp
endif

ifeq ($(BR2_TARGET_LPC32XXCDL_BOARDNAME),"phy3250")
LPC32XXCDL_KICKSTART = kickstart/kickstart_nand
LPC32XXCDL_KICKSTART_BURNER = nand/kickstart
LPC32XXCDL_S1L = s1l/s1l_nand_boot
LPC32XXCDL_S1L_BURNER = nand/s1lapp
endif

ifeq ($(BR2_TARGET_LPC32XXCDL_BOARDNAME),"fdi3250")
LPC32XXCDL_KICKSTART = kickstart/nand
LPC32XXCDL_KICKSTART_BURNER = nand/kickstart_jtag
LPC32XXCDL_S1L = s1l
LPC32XXCDL_S1L_BURNER = nand/s1lapp_jtag
endif

LPC32XXCDL_BUILD_FLAGS = \
	CROSS_COMPILE=$(TARGET_CROSS) \
	NXPMCU_WINBASE=$(@D) \
	NXPMCU_SOFTWARE=$(@D) \
	BSP=$(BR2_TARGET_LPC32XXCDL_BOARDNAME) \
	CSP=lpc32xx TOOL=gnu GEN=lpc

LPC32XXCDL_BOARD_STARTUP_DIR = \
	csps/lpc32xx/bsps/$(BR2_TARGET_LPC32XXCDL_BOARDNAME)/startup/examples/

# Source files are with dos newlines, which our patch infrastructure doesn't
# handle. Work around it by converting the affected files to unix newlines
# before patching
define LPC32XXCDL_EXTRACT_CMDS
	unzip $(LPC32XXCDL_DL_DIR)/$(LPC32XXCDL_SOURCE) -d $(@D)
	mv $(@D)/lpc3xxx_cdl/* $(@D)
	rmdir $(@D)/lpc3xxx_cdl/
	sed -n 's|^[+-]\{3\} [^/]\+\([^ \t]*\)\(.*\)|$(@D)\1|p' \
		boot/lpc32xxcdl/*.patch| sort -u | xargs $(SED) 's/\x0D$$//'
endef

define LPC32XXCDL_BUILD_CMDS
	$(MAKE1) $(LPC32XXCDL_BUILD_FLAGS) -C $(@D)
	$(MAKE1) $(LPC32XXCDL_BUILD_FLAGS) -C $(@D)/$(LPC32XXCDL_BOARD_STARTUP_DIR)/Burners/$(LPC32XXCDL_KICKSTART_BURNER)
	$(MAKE1) $(LPC32XXCDL_BUILD_FLAGS) -C $(@D)/$(LPC32XXCDL_BOARD_STARTUP_DIR)/$(LPC32XXCDL_KICKSTART)
	$(MAKE1) $(LPC32XXCDL_BUILD_FLAGS) -C $(@D)/$(LPC32XXCDL_BOARD_STARTUP_DIR)/Burners/$(LPC32XXCDL_S1L_BURNER)
	$(MAKE1) $(LPC32XXCDL_BUILD_FLAGS) -C $(@D)/$(LPC32XXCDL_BOARD_STARTUP_DIR)/$(LPC32XXCDL_S1L)
endef

define LPC32XXCDL_INSTALL_IMAGES_CMDS
	cp $(@D)/$(LPC32XXCDL_BOARD_STARTUP_DIR)/Burners/$(LPC32XXCDL_KICKSTART_BURNER)/*gnu.bin $(BINARIES_DIR)
	cp $(@D)/$(LPC32XXCDL_BOARD_STARTUP_DIR)/$(LPC32XXCDL_KICKSTART)/*gnu.bin $(BINARIES_DIR)
	cp $(@D)/$(LPC32XXCDL_BOARD_STARTUP_DIR)/Burners/$(LPC32XXCDL_S1L_BURNER)/*gnu.bin $(BINARIES_DIR)
	cp $(@D)/$(LPC32XXCDL_BOARD_STARTUP_DIR)/$(LPC32XXCDL_S1L)/*gnu.bin $(BINARIES_DIR)
endef

$(eval $(generic-package))
