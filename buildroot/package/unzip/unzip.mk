################################################################################
#
# unzip
#
################################################################################

UNZIP_VERSION = 6.0
UNZIP_SOURCE = unzip_$(UNZIP_VERSION).orig.tar.gz
UNZIP_PATCH = unzip_$(UNZIP_VERSION)-26.debian.tar.xz
UNZIP_SITE = https://snapshot.debian.org/archive/debian/20210110T204103Z/pool/main/u/unzip
UNZIP_LICENSE = Info-ZIP
UNZIP_LICENSE_FILES = LICENSE
UNZIP_CPE_ID_VENDOR = unzip_project

# unzip_$(UNZIP_VERSION)-26.debian.tar.xz has patches to fix:
UNZIP_IGNORE_CVES = \
	CVE-2014-8139 \
	CVE-2014-8140 \
	CVE-2014-8141 \
	CVE-2014-9636 \
	CVE-2014-9913 \
	CVE-2015-7696 \
	CVE-2015-7697 \
	CVE-2016-9844 \
	CVE-2018-18384 \
	CVE-2018-1000035 \
	CVE-2019-13232

$(eval $(cmake-package))
