################################################################################
#
# perl-mail-dkim
#
################################################################################

PERL_MAIL_DKIM_VERSION = 1.20200824
PERL_MAIL_DKIM_SOURCE = Mail-DKIM-$(PERL_MAIL_DKIM_VERSION).tar.gz
PERL_MAIL_DKIM_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MB/MBRADSHAW
PERL_MAIL_DKIM_LICENSE = Artistic or GPL-1.0+
PERL_MAIL_DKIM_LICENSE_FILES = LICENSE
PERL_MAIL_DKIM_DISTNAME = Mail-DKIM

$(eval $(perl-package))
