test -n "${BOOT_ORDER}" || setenv BOOT_ORDER "A B"
test -n "${BOOT_A_LEFT}" || setenv BOOT_A_LEFT 3
test -n "${BOOT_B_LEFT}" || setenv BOOT_B_LEFT 3

# HassOS bootargs
setenv bootargs_hassos "zram.enabled=1 zram.num_devices=3 apparmor=1 security=apparmor rootwait"

# HassOS system A/B
setenv bootargs_a "root=PARTUUID=8d3d53e3-6d49-4c38-8349-aff6859e82fd rootfstype=squashfs ro"
setenv bootargs_b "root=PARTUUID=a3ec664e-32ce-4665-95ea-7ae90ce9aa20 rootfstype=squashfs ro"

# Preserve origin bootargs
setenv bootargs_rpi
fdt addr ${fdt_addr}
fdt get value bootargs_rpi /chosen bootargs

setenv bootargs
for BOOT_SLOT in "${BOOT_ORDER}"; do
  if test "x${bootargs}" != "x"; then
    # skip remaining slots
  elif test "x${BOOT_SLOT}" = "xA"; then
    if test ${BOOT_A_LEFT} -gt 0; then
      setexpr BOOT_A_LEFT ${BOOT_A_LEFT} - 1
      echo "Found valid slot A, ${BOOT_A_LEFT} attempts remaining"
      setenv load_kernel "ext4load mmc 0:2 ${kernel_addr_r} zImage"
      setenv bootargs "${bootargs_hassos} ${bootargs_rpi} ${bootargs_a} rauc.slot=A"
    fi
  elif test "x${BOOT_SLOT}" = "xB"; then
    if test ${BOOT_B_LEFT} -gt 0; then
      setexpr BOOT_B_LEFT ${BOOT_B_LEFT} - 1
      echo "Found valid slot B, ${BOOT_B_LEFT} attempts remaining"
      setenv load_kernel "ext4load mmc 0:4 ${kernel_addr_r} zImage"
      setenv bootargs "${bootargs_hassos} ${bootargs_rpi} ${bootargs_b} rauc.slot=B"
    fi
  fi
done

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
bootz ${kernel_addr_r} - ${fdt_addr}
