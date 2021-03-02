from tests.package.test_lua import TestLuaBase


class TestLuaLuaLdap(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUALDAP=y
        """

    def test_run(self):
        self.login()
        self.module_test("lualdap")


class TestLuajitLuaLdap(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUALDAP=y
        """

    def test_run(self):
        self.login()
        self.module_test("lualdap")
