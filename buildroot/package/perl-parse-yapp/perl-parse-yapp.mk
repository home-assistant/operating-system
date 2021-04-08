################################################################################
#
# perl-parse-yapp
#
################################################################################

PERL_PARSE_YAPP_VERSION = 1.21
PERL_PARSE_YAPP_SOURCE = Parse-Yapp-$(PERL_PARSE_YAPP_VERSION).tar.gz
PERL_PARSE_YAPP_SITE = $(BR2_CPAN_MIRROR)/authors/id/W/WB/WBRASWELL
PERL_PARSE_YAPP_LICENSE = Artistic or GPL-1.0+
PERL_PARSE_YAPP_LICENSE_FILES = lib/Parse/Yapp.pm
PERL_PARSE_YAPP_DISTNAME = Parse-Yapp

$(eval $(perl-package))
$(eval $(host-perl-package))
