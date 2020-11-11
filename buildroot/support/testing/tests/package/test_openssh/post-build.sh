#!/usr/bin/env bash

cat <<_EOF_ >>"${TARGET_DIR}/etc/ssh/sshd_config"
PermitRootLogin yes
PasswordAuthentication yes
_EOF_
