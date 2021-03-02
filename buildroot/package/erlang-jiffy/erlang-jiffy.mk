################################################################################
#
# erlang-jiffy
#
################################################################################

ERLANG_JIFFY_VERSION = 1.0.6
ERLANG_JIFFY_SITE = $(call github,davisp,jiffy,$(ERLANG_JIFFY_VERSION))
ERLANG_JIFFY_LICENSE = MIT (core), \
	BSD-3-Clause (Google double conversion library), \
	BSD-3-Clause (tests)
ERLANG_JIFFY_LICENSE_FILES = LICENSE

$(eval $(rebar-package))
