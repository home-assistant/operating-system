import infra
import subprocess
import json


class CpeIdTest(infra.basetest.BRConfigTest):
    config = ""
    br2_external = [infra.filepath("tests/core/cpeid-br2-external")]

    def get_vars(self, var):
        cmd = ["make", "--no-print-directory", "-C", self.b.builddir,
               "VARS=%s%%" % var, "printvars"]
        lines = subprocess.check_output(cmd).splitlines()
        return dict([str(x, "utf-8").split("=") for x in lines])

    def get_json(self, pkg):
        cmd = ["make", "--no-print-directory", "-C", self.b.builddir,
               "%s-show-info" % pkg]
        return json.loads(subprocess.check_output(cmd))

    def test_pkg1(self):
        # this package has no CPE ID information, it should not have
        # any CPE_ID variable defined.
        pkg_vars = self.get_vars("CPE_ID_PKG1_CPE_ID")
        cpe_vars = ["CPE_ID_VALID", "CPE_ID_PRODUCT", "CPE_ID_VERSION", "CPE_ID_UPDATE",
                    "CPE_ID_PREFIX", "CPE_ID"]
        for v in cpe_vars:
            self.assertNotIn("CPE_ID_PKG1_%s" % v, pkg_vars)
        pkg_json = self.get_json("cpe-id-pkg1")
        self.assertNotIn("cpe-id", pkg_json['cpe-id-pkg1'])

        pkg_vars = self.get_vars("HOST_CPE_ID_PKG1_CPE_ID")
        for v in cpe_vars:
            self.assertNotIn("HOST_CPE_ID_PKG1_%s" % v, pkg_vars)
        pkg_json = self.get_json("host-cpe-id-pkg1")
        self.assertNotIn("cpe-id", pkg_json['host-cpe-id-pkg1'])

    def test_pkg2(self):
        # this package has no CPE ID information, it should not have
        # any CPE_ID variable defined.
        pkg_vars = self.get_vars("HOST_CPE_ID_PKG2_CPE_ID")
        cpe_vars = ["CPE_ID_VALID", "CPE_ID_PRODUCT", "CPE_ID_VERSION", "CPE_ID_UPDATE",
                    "CPE_ID_PREFIX", "CPE_ID"]
        for v in cpe_vars:
            self.assertNotIn("HOST_CPE_ID_PKG2_%s" % v, pkg_vars)
        pkg_json = self.get_json("host-cpe-id-pkg2")
        self.assertNotIn("cpe-id", pkg_json['host-cpe-id-pkg2'])

    def test_pkg3(self):
        # this package has just <pkg>_CPE_ID_VENDOR defined, so verify
        # it has the default CPE_ID value, and that inheritance of the
        # values for the host package is working
        pkg_vars = self.get_vars("CPE_ID_PKG3_CPE_ID")
        self.assertEqual(pkg_vars["CPE_ID_PKG3_CPE_ID"],
                         "cpe:2.3:a:cpe-id-pkg3_project:cpe-id-pkg3:67:*:*:*:*:*:*:*")
        self.assertEqual(pkg_vars["CPE_ID_PKG3_CPE_ID_VALID"], "YES")
        pkg_json = self.get_json("cpe-id-pkg3")
        self.assertEqual(pkg_json['cpe-id-pkg3']['cpe-id'],
                         "cpe:2.3:a:cpe-id-pkg3_project:cpe-id-pkg3:67:*:*:*:*:*:*:*")

        pkg_vars = self.get_vars("HOST_CPE_ID_PKG3_CPE_ID")
        self.assertEqual(pkg_vars["HOST_CPE_ID_PKG3_CPE_ID"],
                         "cpe:2.3:a:cpe-id-pkg3_project:cpe-id-pkg3:67:*:*:*:*:*:*:*")
        self.assertEqual(pkg_vars["HOST_CPE_ID_PKG3_CPE_ID_VALID"], "YES")
        pkg_json = self.get_json("host-cpe-id-pkg3")
        self.assertEqual(pkg_json['host-cpe-id-pkg3']['cpe-id'],
                         "cpe:2.3:a:cpe-id-pkg3_project:cpe-id-pkg3:67:*:*:*:*:*:*:*")

    def test_pkg4(self):
        # this package defines
        # <pkg>_CPE_ID_{VENDOR,PRODUCT,VERSION,UPDATE,PREFIX},
        # make sure we get the computed <pkg>_CPE_ID, and that it is
        # inherited by the host variant
        pkg_vars = self.get_vars("CPE_ID_PKG4_CPE_ID")
        self.assertEqual(pkg_vars["CPE_ID_PKG4_CPE_ID"],
                         "cpe:2.4:a:foo:bar:42:b2:*:*:*:*:*:*")
        self.assertEqual(pkg_vars["CPE_ID_PKG4_CPE_ID_VALID"], "YES")
        pkg_json = self.get_json("cpe-id-pkg4")
        self.assertEqual(pkg_json['cpe-id-pkg4']['cpe-id'],
                         "cpe:2.4:a:foo:bar:42:b2:*:*:*:*:*:*")

        pkg_vars = self.get_vars("HOST_CPE_ID_PKG4_CPE_ID")
        self.assertEqual(pkg_vars["HOST_CPE_ID_PKG4_CPE_ID"],
                         "cpe:2.4:a:foo:bar:42:b2:*:*:*:*:*:*")
        self.assertEqual(pkg_vars["HOST_CPE_ID_PKG4_CPE_ID_VALID"], "YES")
        pkg_json = self.get_json("host-cpe-id-pkg4")
        self.assertEqual(pkg_json['host-cpe-id-pkg4']['cpe-id'],
                         "cpe:2.4:a:foo:bar:42:b2:*:*:*:*:*:*")

    def test_pkg5(self):
        # this package defines
        # <pkg>_CPE_ID_{VENDOR,PRODUCT,VERSION,UPDATE,PREFIX} and
        # HOST_<pkg>_CPE_ID_{VENDOR,PRODUCT,VERSION,UPDATE,PREFIX}
        # separately, with different values. Make sure we get the
        # right <pkg>_CPE_ID and HOST_<pkg>_CPE_ID values.
        pkg_vars = self.get_vars("CPE_ID_PKG5_CPE_ID")
        self.assertEqual(pkg_vars["CPE_ID_PKG5_CPE_ID"],
                         "cpe:2.4:a:foo:bar:42:b2:*:*:*:*:*:*")
        self.assertEqual(pkg_vars["CPE_ID_PKG5_CPE_ID_VALID"], "YES")
        pkg_json = self.get_json("cpe-id-pkg5")
        self.assertEqual(pkg_json['cpe-id-pkg5']['cpe-id'],
                         "cpe:2.4:a:foo:bar:42:b2:*:*:*:*:*:*")

        pkg_vars = self.get_vars("HOST_CPE_ID_PKG5_CPE_ID")
        self.assertEqual(pkg_vars["HOST_CPE_ID_PKG5_CPE_ID"],
                         "cpe:2.5:a:baz:fuz:43:b3:*:*:*:*:*:*")
        self.assertEqual(pkg_vars["HOST_CPE_ID_PKG5_CPE_ID_VALID"], "YES")
        pkg_json = self.get_json("host-cpe-id-pkg5")
        self.assertEqual(pkg_json['host-cpe-id-pkg5']['cpe-id'],
                         "cpe:2.5:a:baz:fuz:43:b3:*:*:*:*:*:*")
