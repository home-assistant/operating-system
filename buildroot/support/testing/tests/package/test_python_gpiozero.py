from tests.package.test_python import TestPythonPackageBase


class TestPythonGpiozero(TestPythonPackageBase):
    config = TestPythonPackageBase.config
    sample_scripts = ["tests/package/sample_python_gpiozero.py"]

    def run_sample_scripts(self):
        cmd = self.interpreter + " sample_python_gpiozero.py"
        output, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "pinout -r a020d3 -m | cat"
        self.assertRunOk(cmd)


class TestPythonPy2Gpiozero(TestPythonGpiozero):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_GPIOZERO=y
        """


class TestPythonPy3Gpiozero(TestPythonGpiozero):
    __test__ = True
    config = TestPythonGpiozero.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_GPIOZERO=y
        """
