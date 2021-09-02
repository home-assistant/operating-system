import os

import infra.basetest


class TestUbootOpensslPkgConfig(infra.basetest.BRTest):
    config = infra.basetest.MINIMAL_CONFIG + \
        """
        BR2_x86_64=y
        BR2_x86_atom=y
        BR2_PACKAGE_OPENSSL=y
        BR2_TARGET_UBOOT=y
        BR2_TARGET_UBOOT_BOARD_DEFCONFIG="efi-x86_payload64"
        BR2_TARGET_UBOOT_NEEDS_OPENSSL=y
        """

    def test_run(self):
        img = os.path.join(self.builddir, "images", "u-boot.bin")
        self.assertTrue(os.path.exists(img))
