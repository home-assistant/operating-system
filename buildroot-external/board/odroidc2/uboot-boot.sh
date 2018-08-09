###################################################
# Changes made to this are overwritten every time there's a new upgrade
# To make your changes permanent change it on
# boot.ini.default
# After changing it on boot.ini.default run the bootini command to
# rewrite this file with your personal permanent settings.
# Documentation: http://odroid.com/dokuwiki/doku.php?id=en:c2_persistent_bootini
########################################################################

# Possible screen resolutions
# Uncomment only a single Line! The line with setenv written.
# At least one mode must be selected.

# Custom modeline!
# To use custom modeline you need to disable all the below resolutions
# and setup your own!
# For more information check our wiki:
# http://odroid.com/dokuwiki/doku.php?id=en:c2_hdmi_autosetting
# Example below:
# setenv m "custombuilt"
# setenv modeline "1920,1200,154000,74040,60,1920,1968,2000,2080,1200,1202,1208,1235,1,0,1"

# 480 Lines (720x480)
# setenv m "480i60hz" # Interlaced 60Hz
# setenv m "480i_rpt" # Interlaced for Rear Projection Televisions 60Hz
# setenv m "480p60hz" # 480 Progressive 60Hz
# setenv m "480p_rpt" # 480 Progressive for Rear Projection Televisions 60Hz

# 576 Lines (720x576)
# setenv m "576i50hz" # Interlaced 50Hz
# setenv m "576i_rpt" # Interlaced for Rear Projection Televisions 50Hz
# setenv m "576p50hz" # Progressive 50Hz
# setenv m "576p_rpt" # Progressive for Rear Projection Televisions 50Hz

# 720 Lines (1280x720)
# setenv m "720p50hz" # 50Hz
# setenv m "720p60hz" # 60Hz

# 1080 Lines (1920x1080)
# setenv m "1080i60hz" # Interlaced 60Hz
setenv m "1080p60hz" # Progressive 60Hz
# setenv m "1080i50hz" # Interlaced 50Hz
# setenv m "1080p50hz" # Progressive 50Hz
# setenv m "1080p24hz" # Progressive 24Hz

# 4K (3840x2160)
# setenv m "2160p30hz"    # Progressive 30Hz
# setenv m "2160p25hz"    # Progressive 25Hz
# setenv m "2160p24hz"    # Progressive 24Hz
# setenv m "smpte24hz"    # Progressive 24Hz SMPTE
# setenv m "2160p50hz"    # Progressive 50Hz
# setenv m "2160p60hz"    # Progressive 60Hz
# setenv m "2160p50hz420" # Progressive 50Hz with YCbCr 4:2:0 (Requires TV/Monitor that supports it)
# setenv m "2160p60hz420" # Progressive 60Hz with YCbCr 4:2:0 (Requires TV/Monitor that supports it)

### VESA modes ###
# setenv m "640x480p60hz"
# setenv m "800x480p60hz"
# setenv m "480x800p60hz"
# setenv m "800x600p60hz"
# setenv m "1024x600p60hz"
# setenv m "1024x768p60hz"
# setenv m "1280x800p60hz"
# setenv m "1280x1024p60hz"
# setenv m "1360x768p60hz"
# setenv m "1440x900p60hz"
# setenv m "1600x900p60hz"
# setenv m "1680x1050p60hz"
# setenv m "1600x1200p60hz"
# setenv m "1920x1200p60hz"
# setenv m "2560x1080p60hz"
# setenv m "2560x1440p60hz"
# setenv m "2560x1600p60hz"
# setenv m "3440x1440p60hz"

# HDMI BPP Mode
setenv m_bpp "32"
# setenv m_bpp "24"
# setenv m_bpp "16"

# HDMI DVI/VGA modes
# By default its set to HDMI, if needed change below.
# Uncomment only a single Line.
# setenv vout "dvi"
# setenv vout "vga"

# HDMI HotPlug Detection control
# Allows you to force HDMI thinking that the cable is connected.
# true = HDMI will believe that cable is always connected
# false = will let board/monitor negotiate the connection status
setenv hpd "true"
# setenv hpd "false"

# Monitor output
# Controls if HDMI PHY should output anything to the monitor
#setenv monitor_onoff "false" # true or false

# Server Mode (aka. No Graphics)
# Setting nographics to 1 will disable all video subsystem
# This mode is ideal of server type usage. (Saves ~300Mb of RAM)
setenv nographics "0"

# Meson Timer
# 1 - Meson Timer
# 0 - Arch Timer
# Using meson_timer improves the video playback however it breaks KVM (virtualization).
# Using arch timer allows KVM/Virtualization to work however you'll experience poor video
#setenv mesontimer "1"

# UHS (Ultra High Speed) MicroSD mode enable/disable
#setenv disableuhs "false"

# MicroSD Card Detection enable/disable
# Force the MMC controlled to believe that a card is connected.
#setenv mmc_removable "true"

# USB Multi WebCam tweak
# Only enable this if you use it.
#setenv usbmulticam "false"

# Default Console Device Setting
#setenv condev "console=ttyS0,115200n8 console=tty0"   # on both

# CPU Frequency / Cores control
###########################################
### WARNING!!! WARNING!!! WARNING!!!
# Before changing anything here please read the wiki entry:
# http://odroid.com/dokuwiki/doku.php?id=en:c2_set_cpu_freq
#
# MAX CPU's
# setenv maxcpus "1"
# setenv maxcpus "2"
# setenv maxcpus "3"
setenv maxcpus "4"

# MAX Frequency
# setenv max_freq "2016"  # 2.016GHz
# setenv max_freq "1944"  # 1.944GHz
# setenv max_freq "1944"  # 1.944GHz
# setenv max_freq "1920"  # 1.920GHz
# setenv max_freq "1896"  # 1.896GHz
# setenv max_freq "1752"  # 1.752GHz
# setenv max_freq "1680"  # 1.680GHz
# setenv max_freq "1656"  # 1.656GHz
setenv max_freq "1536"  # 1.536GHz



###########################################


test -n "${BOOT_ORDER}" || setenv BOOT_ORDER "A B"
test -n "${BOOT_A_LEFT}" || setenv BOOT_A_LEFT 3
test -n "${BOOT_B_LEFT}" || setenv BOOT_B_LEFT 3

# HassOS bootargs
setenv bootargs_hassos "no_console_suspend hdmimode=${m} m_bpp=${m_bpp} net.ifnames=0 elevator=noop disablehpd=${hpd} max_freq=${max_freq} maxcpus=${maxcpus} zram.enabled=1 zram.num_devices=3 apparmor=1 security=apparmor cgroup_enable=memory"

# HassOS system A/B
#setenv bootargs_a "root=PARTUUID=0d3e0000-06 rootfstype=squashfs ro"
#setenv bootargs_b "root=PARTUUID=0d3e0000-08 rootfstype=squashfs ro"

#setenv bootargs_a "root=/dev/mmcblk1p6 rootfstype=squashfs ro rootwait"
#setenv bootargs_b "root=/dev/mmcblk1p8 rootfstype=squashfs ro rootwait"

setenv bootargs_a "root=PARTUUID=0d3e0000-06 rootfstype=squashfs ro rootwait"
setenv bootargs_b "root=PARTUUID=0d3e0000-08 rootfstype=squashfs ro rootwait"

# Preserve origin bootargs
setenv bootargs_odroidc2
setenv fdt_org "0x1000000"
# Load extraargs
fileenv mmc 0:1 ${fdt_org} cmdline.txt cmdline
fatload mmc 0:1 ${fdt_org} meson-gxbb-odroidc2.dtb
fdt addr ${fdt_org}
#fdt get value bootargs_odroidc2 /chosen bootargs


# logical volumes get numbered after physical ones.
# 1. boot
# 2. Extended partition
# 3. Overlay
# 4. Data
# 5. KernelA
# 6. SystemA
# 7. KernelB
# 8. SystemB
# 9. BootInfo
setenv bootargs
for BOOT_SLOT in "${BOOT_ORDER}"; do
  if test "x${bootargs}" != "x"; then
    # skip remaining slots
  elif test "x${BOOT_SLOT}" = "xA"; then
    if test ${BOOT_A_LEFT} -gt 0; then
      setexpr BOOT_A_LEFT ${BOOT_A_LEFT} - 1
      echo "Found valid slot A, ${BOOT_A_LEFT} attempts remaining"
      setenv load_kernel "ext4load mmc 0:5 ${kernel_addr_r} Image"
      setenv bootargs "${bootargs_hassos} ${bootargs_a} rauc.slot=A ${cmdline}"
    fi
  elif test "x${BOOT_SLOT}" = "xB"; then
    if test ${BOOT_B_LEFT} -gt 0; then
      setexpr BOOT_B_LEFT ${BOOT_B_LEFT} - 1
      echo "Found valid slot B, ${BOOT_B_LEFT} attempts remaining"
      setenv load_kernel "ext4load mmc 0:7 ${kernel_addr_r} Image"
      setenv bootargs "${bootargs_hassos} ${bootargs_b} rauc.slot=B ${cmdline}"
    fi
  fi
done

setenv fdt_addr
if test -n "${bootargs}"; then
  saveenv
else
  echo "No valid slot found, resetting tries to 3"
  setenv BOOT_A_LEFT 3
  setenv BOOT_B_LEFT 3
  saveenv
  reset
fi

echo "Loading kernel"
run load_kernel
echo " Starting kernel"
booti ${kernel_addr_r} - ${fdt_org}

echo "Fails on boot"
reset
