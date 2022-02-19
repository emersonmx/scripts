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

# Languages
## Python
install_tool python
python -m pip install --upgrade pip
cat ~/.default-python-packages | xargs -I _ python -m pip install --upgrade _
asdf_reshim_tool python

## NodeJS
install_tool nodejs
cat ~/.default-npm-packages | xargs -I _ npm install -g _
npm update -g
asdf_reshim_tool nodejs

## Golang
install_tool golang
cat ~/.default-golang-pkgs | xargs -I _ go install _
asdf_reshim_tool golang

## Rust
export ASDF_CRATE_DEFAULT_PACKAGES_FILE="/dev/null"
install_tool rust
cat ~/.default-cargo-crates | xargs -I _ cargo install -f _
asdf_reshim_tool rust

## Lua
install_tool lua
cat ~/.default-lua-packages | xargs -I _ bash -c "luarocks install _"
asdf_reshim_tool lua

# Tools
## direnv
install_tool direnv

## k3d
install_tool k3d

## kubectl
install_tool kubectl

export PATH="$_old_path"
