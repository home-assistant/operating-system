################################################################################
#
# python-scapy
#
################################################################################

PYTHON_SCAPY_VERSION = 2.4.4
PYTHON_SCAPY_SOURCE = scapy-$(PYTHON_SCAPY_VERSION).tar.gz
PYTHON_SCAPY_SITE = https://files.pythonhosted.org/packages/c6/8f/438d4d0bab4c8e22906a7401dd082b4c0f914daf2bbdc7e7e8390d81a5c3
PYTHON_SCAPY_SETUP_TYPE = setuptools
PYTHON_SCAPY_LICENSE = GPL-2.0
PYTHON_SCAPY_LICENSE_FILES = LICENSE

$(eval $(python-package))
