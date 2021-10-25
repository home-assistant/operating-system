from tests.init.base import InitSystemBase as InitSystemBase


class InitSystemOpenrcBase(InitSystemBase):
    config = \
        """
        BR2_arm=y
        BR2_cortex_a9=y
        BR2_ARM_ENABLE_VFP=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_INIT_OPENRC=y
        BR2_TARGET_GENERIC_GETTY_PORT="ttyAMA0"
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def check_init(self):
        super(InitSystemOpenrcBase, self).check_init('/sbin/openrc-init')

        # Test all services are OK
        output, _ = self.emulator.run("rc-status -c")
        self.assertEqual(len(output), 0)


class TestInitSystemOpenrcRoFull(InitSystemOpenrcBase):
    config = InitSystemOpenrcBase.config + \
        """
        BR2_SYSTEM_DHCP="eth0"
        # BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW is not set
        BR2_TARGET_ROOTFS_SQUASHFS=y
        """

    def test_run(self):
        self.start_emulator("squashfs")
        self.check_init()


class TestInitSystemOpenrcRwFull(InitSystemOpenrcBase):
    config = InitSystemOpenrcBase.config + \
        """
        BR2_SYSTEM_DHCP="eth0"
        BR2_TARGET_ROOTFS_EXT2=y
        """

    def test_run(self):
        self.start_emulator("ext2")
        self.check_init()
