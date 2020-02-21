#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

(cd ~/.local/bin && ln -sf $SCRIPT_DIR/dmenu/rofi.sh dmenu)
