################################################################################
#
# perl-devel-size
#
################################################################################

PERL_DEVEL_SIZE_VERSION = 0.83
PERL_DEVEL_SIZE_SOURCE = Devel-Size-$(PERL_DEVEL_SIZE_VERSION).tar.gz
PERL_DEVEL_SIZE_SITE = $(BR2_CPAN_MIRROR)/authors/id/N/NW/NWCLARK
PERL_DEVEL_SIZE_LICENSE = Artistic or GPL-1.0+
PERL_DEVEL_SIZE_LICENSE_FILES = README
PERL_DEVEL_SIZE_DISTNAME = Devel-Size

$(eval $(perl-package))
