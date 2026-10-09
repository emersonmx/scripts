#!/bin/bash

set -euo pipefail

./system.sh
./flatpak.sh

./tmux.sh
./tldr.sh
./zsh.sh
./pnpm.sh
./claude.sh
./android.sh

./asdf.sh
