#!/bin/bash

set -e

cd "$(dirname "$0")"

if [ -z "$GITHUB_ACTIONS" ] && [ -z "$VIRTUAL_ENV" ]; then
  # Environment should be set up in separate GHA steps - which can also
  # handle caching of the dependecies, etc.
  python3 -m venv venv
  # shellcheck disable=SC1091
  source venv/bin/activate
  pip3 install -r requirements.txt
fi

pytest --lg-env qemu-strategy.yaml --lg-log=lg_logs --junitxml=junit_reports/tests.xml "$@"
