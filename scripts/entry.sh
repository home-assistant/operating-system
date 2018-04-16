#!/bin/bash
set -e

# Run dockerd
dockerd -s vfs &> /dev/null &

exec bash
