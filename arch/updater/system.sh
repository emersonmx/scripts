#!/bin/bash

_old_path="$PATH"
export PATH=$(echo $PATH | sed "s#$USER_LOCAL/bin:##")

yay -Syu

sudo -k

export PATH="$_old_path"
