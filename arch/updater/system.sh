#!/bin/bash

_old_path="$PATH"
export PATH=$(echo $PATH | sed -e "s#$HOME_LOCAL/bin:##" -e "s#$HOME_LOCAL/share/asdf/shims:##g")

yay -Syu

sudo -k

export PATH="$_old_path"
