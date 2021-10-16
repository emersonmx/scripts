#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

nvim +PlugInstall +PlugUpdate +UpdateRemotePlugins +qall
nvim +CocUpdateSync +qall
