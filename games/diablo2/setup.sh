#!/usr/bin/env bash

save_dir="$HOME/.config/wineprefix/default/drive_c/users/emersonmx/Saved Games/Diablo II"

rm -f "$save_dir"
ln -sf "$(realpath Game)" "$save_dir"
ln -sf "$(realpath "Diablo II.desktop")" "$HOME/.local/share/applications/"
