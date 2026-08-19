#!/usr/bin/env bash
set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
export ARIA2_BUILD_SYSTEM=cmake
export ARIA2_REPOSITORY="${ARIA2_REPOSITORY:-https://github.com/AnInsomniacy/aria2-next.git}"
export ARIA2_REF="${ARIA2_REF:-main}"
export ARIA2_BINARY=aria2-next

exec "$SCRIPT_DIR/aria2-gnu-linux-cross-build-armhf.sh" "$@"
