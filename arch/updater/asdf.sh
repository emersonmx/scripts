#!/bin/bash

asdf_install_tool() {
    name="$1"
    version="${2:-latest}"
    asdf install $name $version
}

asdf_uninstall_tool() {
    name="$1"
    version="$2"
    asdf uninstall $name $version
}

asdf_global_tool() {
    name="$1"
    version="${2:-latest}"
    asdf global $name $version
}

asdf_reshim_tool() {
    name="$1"
    version="${2:-latest}"
    asdf reshim $name $version
}

install_tool() {
    name="$1"
    version="${2:-latest}"
    asdf_install_tool $name $version
    asdf_global_tool $name $version
    asdf_reshim_tool $name $version
}

_old_path="$PATH"
export PATH=$(echo $PATH | sed "s#$USER_LOCAL/bin:##")

# ASDF
asdf update
asdf plugin update --all

# Python
install_tool python
python -m pip install --upgrade pip
cat ~/.default-python-packages | xargs -I _ python -m pip install --upgrade _
asdf_reshim_tool python

# NodeJS
install_tool nodejs
cat ~/.default-npm-packages | xargs -I _ npm install -g _
npm update -g
asdf_reshim_tool nodejs

# Golang
install_tool golang
cat ~/.default-golang-pkgs | xargs -I _ go install _
asdf_reshim_tool golang

# Rust
asdf_uninstall_tool rust stable
install_tool rust stable

# Lua
install_tool lua

# direnv
install_tool direnv

export PATH="$_old_path"
