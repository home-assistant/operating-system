################################################################################
#
# python-ansicolors
#
################################################################################

PYTHON_ANSICOLORS_VERSION = 1.1.8
PYTHON_ANSICOLORS_SOURCE = ansicolors-$(PYTHON_ANSICOLORS_VERSION).zip
PYTHON_ANSICOLORS_SITE = https://files.pythonhosted.org/packages/76/31/7faed52088732704523c259e24c26ce6f2f33fbeff2ff59274560c27628e
PYTHON_ANSICOLORS_SETUP_TYPE = setuptools
PYTHON_ANSICOLORS_LICENSE = ISC
PYTHON_ANSICOLORS_LICENSE_FILES = LICENSE

define PYTHON_ANSICOLORS_EXTRACT_CMDS
	unzip $(PYTHON_ANSICOLORS_DL_DIR)/$(PYTHON_ANSICOLORS_SOURCE) -d $(@D)
	mv $(@D)/ansicolors-$(PYTHON_ANSICOLORS_VERSION)/* $(@D)
	$(RM) -r $(@D)/ansicolors-$(PYTHON_ANSICOLORS_VERSION)
endef

$(eval $(python-package))
