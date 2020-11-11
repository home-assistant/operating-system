import os

from tests.package.test_python import TestPythonPackageBase


class TestPythonPy3Pytest(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_PYTEST=y
        """
    sample_scripts = ["tests/package/sample_python_pytest.py"]

    def run_sample_scripts(self):
        for script in self.sample_scripts:
            cmd = self.interpreter + " -m pytest " + os.path.basename(script)
            _, exit_code = self.emulator.run(cmd, timeout=self.timeout)
            self.assertEqual(exit_code, 0)
