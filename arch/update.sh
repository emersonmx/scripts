#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

_old_path="$PATH"
export PATH=$(echo $PATH | sed "s#$USER_LOCAL/bin:##")

[[ ${UPDATE_MIRRORLIST:-1} == 1 ]] \
    && sudo $script_dir/reflector.sh

[[ ${UPDATE_SYSTEM:-1} == 1 ]] \
    && yay -Syu

sudo -k

export PATH="$_old_path"

[[ ${UPDATE_RUST:-1} == 1 ]] \
    && rustup self update \
    && rustup update

[[ ${UPDATE_CARGO:-1} == 1 ]] \
    && cargo install --force \
        cargo-watch \
        tealdeer

[[ ${UPDATE_GO:-1} == 1 ]] \
    && go get -v -u \
        github.com/sourcegraph/go-langserver \
        github.com/mattn/efm-langserver \
        github.com/kisielk/errcheck \
        golang.org/x/lint/golint

[[ ${UPDATE_NPM:-1} == 1 ]] \
    && npm update -g

PIP=pip3
[[ ${UPDATE_PIP:-1} == 1 ]] \
    && $PIP list --user --outdated --format=freeze \
        | grep -v '^\-e' \
        | cut -d = -f 1 \
        | xargs -n1 $PIP install --upgrade

[[ ${UPDATE_FLATPAK:-1} == 1 ]] \
    && flatpak update -y

[[ ${UPDATE_TLDR:-1} == 1 ]] \
    && tldr --update

[[ ${UPDATE_ZINIT:-1} == 1 ]] \
    && zsh -i -c 'zinit self-update' \
    && zsh -i -c 'zinit update'

[[ ${UPDATE_NVIM:-1} == 1 ]] \
    && nvim +PlugInstall +PlugUpdate +UpdateRemotePlugins +qall \
    && nvim +CocUpdateSync +qall

[[ ${INSTALL_PYNVIM:-1} == 1 ]] \
    && python3 -m pip install --user --upgrade pynvim \
    && python2 -m pip install --user --upgrade pynvim

[[ ${UPDATE_TMUX_PLUGINS:-1} == 1 ]] \
    && ~/.tmux/plugins/tpm/bindings/update_plugins
