Run the emulation with:

  qemu-system-s390x -M s390-ccw-virtio -cpu max,zpci=on -m 4G -smp 2 \
    -kernel output/images/bzImage -drive file=output/images/rootfs.ext2,if=virtio,format=raw \
    -append "rootwait root=/dev/vda net.ifnames=0 biosdevname=0" -display none -serial mon:stdio \
    -net nic,model=virtio -net user # qemu_s390x_defconfig

The login prompt will appear in the terminal that started Qemu.
