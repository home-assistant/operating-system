################################################################################
#
# host-mender-artifact
#
################################################################################

HOST_MENDER_ARTIFACT_VERSION = 3.4.0
HOST_MENDER_ARTIFACT_SITE = $(call github,mendersoftware,mender-artifact,$(HOST_MENDER_ARTIFACT_VERSION))
HOST_MENDER_ARTIFACT_LICENSE = Apache2.0, BSD-2-Clause, BSD-3-Clause, ISC, MIT
HOST_MENDER_ARTIFACT_LICENSE_FILES = \
	LICENSE \
	LIC_FILES_CHKSUM.sha256 \
	vendor/github.com/mendersoftware/mendertesting/LICENSE \
	vendor/github.com/minio/sha256-simd/LICENSE \
	vendor/gopkg.in/yaml.v2/LICENSE \
	vendor/github.com/pkg/errors/LICENSE \
	vendor/github.com/pmezard/go-difflib/LICENSE \
	vendor/golang.org/x/sys/LICENSE \
	vendor/golang.org/x/crypto/LICENSE \
	vendor/github.com/remyoudompheng/go-liblzma/LICENSE \
	vendor/github.com/klauspost/compress/LICENSE \
	vendor/github.com/russross/blackfriday/v2/LICENSE.txt \
	vendor/github.com/davecgh/go-spew/LICENSE \
	vendor/github.com/stretchr/testify/LICENSE \
	vendor/github.com/urfave/cli/LICENSE \
	vendor/github.com/sirupsen/logrus/LICENSE \
	vendor/github.com/klauspost/pgzip/LICENSE \
	vendor/github.com/cpuguy83/go-md2man/v2/LICENSE.md \
	vendor/github.com/shurcooL/sanitized_anchor_name/LICENSE

HOST_MENDER_ARTIFACT_DEPENDENCIES = host-xz

# By default, go will attempt to download needed modules before building, which
# is not desirable. This behavior also causes permission issues when cleaning,
# as go downloads modules as read-only by default. Because mender-artifact
# includes the modules in the vendor directory, mod=vendor prevents the package
# from downloading the go modules during the build process and prevents
# permission issues when cleaning.
HOST_MENDER_ARTIFACT_GO_ENV = GOFLAGS="-mod=vendor"

HOST_MENDER_ARTIFACT_LDFLAGS = -X main.Version=$(HOST_MENDER_ARTIFACT_VERSION)

HOST_MENDER_ARTIFACT_BUILD_TARGETS = cli/mender-artifact

HOST_MENDER_ARTIFACT_BIN_NAME = mender-artifact
HOST_MENDER_ARTIFACT_INSTALL_BINS = $(HOST_MENDER_ARTIFACT_BIN_NAME)

$(eval $(host-golang-package))
