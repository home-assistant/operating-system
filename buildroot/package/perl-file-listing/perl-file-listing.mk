################################################################################
#
# perl-file-listing
#
################################################################################

PERL_FILE_LISTING_VERSION = 6.14
PERL_FILE_LISTING_SOURCE = File-Listing-$(PERL_FILE_LISTING_VERSION).tar.gz
PERL_FILE_LISTING_SITE = $(BR2_CPAN_MIRROR)/authors/id/P/PL/PLICEASE
PERL_FILE_LISTING_LICENSE = Artistic or GPL-1.0+
PERL_FILE_LISTING_LICENSE_FILES = LICENSE
PERL_FILE_LISTING_DISTNAME = File-Listing

$(eval $(perl-package))
