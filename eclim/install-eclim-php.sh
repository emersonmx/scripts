#!/bin/bash

local_path="$HOME/.local"
opt_path="$local_path/opt"
vim_plugin_path="$HOME/.vim/pack/minpac/opt/vim-eclim"
eclipse_path="$opt_path/eclipse-php"

mkdir -p $vim_plugin_path

./eclim_2.7.1.bin \
    --eclipse=$eclipse_path \
    --vimfiles=$vim_plugin_path \
    --plugins=pdt

ln -sf $(pwd)/eclipse-php.desktop "$local_path/share/applications/"
ln -sf $(pwd)/eclimd-php "$local_path/bin/"
