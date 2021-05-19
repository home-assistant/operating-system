################################################################################
#
# c-periphery
#
################################################################################

C_PERIPHERY_VERSION = 2.3.1
C_PERIPHERY_SITE = $(call github,vsergeev,c-periphery,v$(C_PERIPHERY_VERSION))
C_PERIPHERY_INSTALL_STAGING = YES
C_PERIPHERY_LICENSE = MIT
C_PERIPHERY_LICENSE_FILES = LICENSE
C_PERIPHERY_CPE_ID_VENDOR = c-periphery_project

$(eval $(cmake-package))
