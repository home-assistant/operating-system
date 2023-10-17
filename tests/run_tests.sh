#!/bin/bash

set -e

if [ ! -n "$GITHUB_ACTIONS" ] && [ ! -n "$VIRTUAL_ENV" ]; then
  # Environment should be set up in separate GHA steps - which can also
  # handle caching of the dependecies, etc.
  python3 -m venv venv
  source venv/bin/activate
  pip3 install -r requirements.txt
fi

pytest --lg-env qemu-strategy.yaml --lg-log=lg_logs --junitxml=junit_reports/smoke_test.xml smoke_test
