#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

asdf_install_tool() {
    name="$1"
    version="${2:-latest}"
    asdf install $name $version
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
install_tool rust stable
cargo install --force $(cat ~/.default-cargo-crates)
asdf_reshim_tool rust stable
