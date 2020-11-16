import os

import infra.basetest


class TestSELinuxInfra(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG +\
        """
        BR2_PACKAGE_REFPOLICY=y
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_SETOOLS=y
        BR2_TARGET_ROOTFS_CPIO=y
        """

    def base_test_run(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5", kernel="builtin",
                           options=["-initrd", cpio_file])
        self.emulator.login()


class TestSELinuxExtraModules(TestSELinuxInfra):
    config = TestSELinuxInfra.config + \
        """
        BR2_REFPOLICY_EXTRA_MODULES="ntp tor"
        """

    def test_run(self):
        TestSELinuxInfra.base_test_run(self)

        out, ret = self.emulator.run("seinfo -t ntpd_t", 15)
        self.assertEqual(ret, 0)
        self.assertEqual(out[2].strip(), "ntpd_t")

        out, ret = self.emulator.run("seinfo -t tor_t", 15)
        self.assertEqual(ret, 0)
        self.assertEqual(out[2].strip(), "tor_t")


class TestSELinuxExtraModulesDirs(TestSELinuxInfra):
    config = TestSELinuxInfra.config + \
        """
        BR2_REFPOLICY_EXTRA_MODULES_DIRS="{}"
        """.format(infra.filepath("tests/core/test_selinux/extra_modules"))

    def test_run(self):
        TestSELinuxInfra.base_test_run(self)

        out, ret = self.emulator.run("seinfo -t buildroot_test_t", 15)
        self.assertEqual(ret, 0)
        self.assertEqual(out[2].strip(), "buildroot_test_t")


class TestSELinuxCustomGit(TestSELinuxInfra):
    config = TestSELinuxInfra.config + \
        """
        BR2_PACKAGE_REFPOLICY_CUSTOM_GIT=y
        BR2_PACKAGE_REFPOLICY_CUSTOM_REPO_URL="https://github.com/SELinuxProject/refpolicy.git"
        BR2_PACKAGE_REFPOLICY_CUSTOM_REPO_VERSION="RELEASE_2_20200818"
        """

    def test_run(self):
        pass


class TestSELinuxPackage(TestSELinuxInfra):
    br2_external = [infra.filepath("tests/core/test_selinux/br2_external")]
    config = TestSELinuxInfra.config + \
        """
        BR2_PACKAGE_SELINUX_TEST=y
        """

    def test_run(self):
        TestSELinuxInfra.base_test_run(self)

        out, ret = self.emulator.run("seinfo -t ntpd_t", 15)
        self.assertEqual(ret, 0)
        self.assertEqual(out[2].strip(), "ntpd_t")

        out, ret = self.emulator.run("seinfo -t tor_t", 15)
        self.assertEqual(ret, 0)
        self.assertEqual(out[2].strip(), "tor_t")

        out, ret = self.emulator.run("seinfo -t buildroot_test_t", 15)
        self.assertEqual(ret, 0)
        self.assertEqual(out[2].strip(), "buildroot_test_t")
