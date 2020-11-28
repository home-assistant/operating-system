from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Colorzero(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_COLORZERO=y
        """
    sample_scripts = ["tests/package/sample_python_colorzero.py"]
    timeout = 30


class TestPythonPy3Colorzero(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_COLORZERO=y
        """
    sample_scripts = ["tests/package/sample_python_colorzero.py"]
    timeout = 30
