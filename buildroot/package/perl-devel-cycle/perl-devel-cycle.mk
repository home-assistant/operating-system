################################################################################
#
# perl-devel-cycle
#
################################################################################

PERL_DEVEL_CYCLE_VERSION = 1.12
PERL_DEVEL_CYCLE_SOURCE = Devel-Cycle-$(PERL_DEVEL_CYCLE_VERSION).tar.gz
PERL_DEVEL_CYCLE_SITE = $(BR2_CPAN_MIRROR)/authors/id/L/LD/LDS
PERL_DEVEL_CYCLE_LICENSE = Artistic or GPL-1.0+
PERL_DEVEL_CYCLE_LICENSE_FILES = README
PERL_DEVEL_CYCLE_DISTNAME = Devel-Cycle

$(eval $(perl-package))
