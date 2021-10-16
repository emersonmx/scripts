#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

zsh -i -c 'zinit self-update'
zsh -i -c 'zinit update'
