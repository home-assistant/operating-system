################################################################################
#
# perl-params-util
#
################################################################################

PERL_PARAMS_UTIL_VERSION = 1.101
PERL_PARAMS_UTIL_SOURCE = Params-Util-$(PERL_PARAMS_UTIL_VERSION).tar.gz
PERL_PARAMS_UTIL_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RE/REHSACK
PERL_PARAMS_UTIL_LICENSE = Artistic or GPL-1.0+
PERL_PARAMS_UTIL_LICENSE_FILES = ARTISTIC-1.0 GPL-1 LICENSE
PERL_PARAMS_UTIL_DISTNAME = Params-Util

$(eval $(perl-package))
