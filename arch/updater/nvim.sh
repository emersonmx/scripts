#!/bin/bash

nvim \
    --noplugin \
    -u "$HOME/.config/nvim/lua/emersonmx/packer.lua" \
    -c "PackerSync"

nvim --headless -c "MasonUpdate" -c "qall"
nvim --headless -c "TSUpdateSync" -c "qall"
nvim -c "Mason"
