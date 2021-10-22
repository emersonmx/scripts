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
npm update -g
asdf_reshim_tool nodejs

# direnv
install_tool direnv

# Golang
install_tool golang
go install $(cat ~/.default-golang-pkgs)
asdf_reshim_tool golang

# Rust
asdf_uninstall_tool rust stable
install_tool rust stable

export PATH="$_old_path"
