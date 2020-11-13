from tests.package.test_python import TestPythonPackageBase


class TestPythonPy3RpiGpio(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_RPI_GPIO=y
        """
    sample_scripts = ["tests/package/sample_python_rpi_gpio.py"]
