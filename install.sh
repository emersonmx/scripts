#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

(cd ~/.local/bin && ln -sf $SCRIPT_DIR/vim/vimopen.sh)
(cd ~/.local/share/applications && ln -sf $SCRIPT_DIR/vim/vimeclipse.sh)