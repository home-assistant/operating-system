################################################################################
#
# perl-math-int64
#
################################################################################

PERL_MATH_INT64_VERSION = 0.54
PERL_MATH_INT64_SOURCE = Math-Int64-$(PERL_MATH_INT64_VERSION).tar.gz
PERL_MATH_INT64_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SA/SALVA
PERL_MATH_INT64_LICENSE = Artistic or GPL-1.0+
PERL_MATH_INT64_LICENSE_FILES = COPYING
PERL_MATH_INT64_DISTNAME = Math-Int64

$(eval $(perl-package))
