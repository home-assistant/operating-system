# If the system lacks bison or flex, add
# dependencies to suitable host packages
#
# BR2_{BISON,FLES}_HOST_DEPENDENCY should only be used to build code
# that runs on host, e.g. Kconfig. To build code for target use plain
# host-{bison,flex}.

ifeq ($(shell which bison 2>/dev/null),)
BR2_BISON_HOST_DEPENDENCY = host-bison
endif

ifeq ($(shell which flex 2>/dev/null),)
BR2_FLEX_HOST_DEPENDENCY = host-flex
endif
