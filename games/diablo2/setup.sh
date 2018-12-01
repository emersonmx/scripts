#!/usr/bin/env bash

save_dir="/mnt/LinBKP/Jogos/PC/Diablo2/saves"
user_save_dir="$HOME/.config/wineprefix/default/drive_c/users/emersonmx/Saved Games/Diablo II"

ln -Tsf "$save_dir" "$user_save_dir"
ln -sf "$(realpath "Diablo II.desktop")" "$HOME/.local/share/applications/"
