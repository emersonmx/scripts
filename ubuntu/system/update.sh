#!/bin/bash

UPDATE_ALL=${UPDATE_ALL:-1}

[[ ${UPDATE_SYSTEM:-$UPDATE_ALL} == 1 ]] \
    && sudo apt-get update -y \
    && sudo apt-get upgrade -y

sudo -k

[[ ${UPDATE_ASDF:-$UPDATE_ALL} == 1 ]] \
    && asdf update \
    && asdf plugin update --all \
    && cat ~/.tool-versions | cut -d' ' -f1 | xargs -I _ asdf install _ latest \
    && cat ~/.tool-versions | cut -d' ' -f1 | xargs -I _ asdf global _ latest

[[ ${UPDATE_CARGO:-$UPDATE_ALL} == 1 ]] \
    && cargo install --force \
        $(cat ~/.default-cargo-crates)

[[ ${UPDATE_GO:-$UPDATE_ALL} == 1 ]] \
    && go install \
        github.com/kisielk/errcheck@latest \
        github.com/mattn/efm-langserver@latest \
        github.com/sourcegraph/go-langserver@latest \
        golang.org/x/lint/golint@latest \
        mvdan.cc/sh/v3/cmd/shfmt@latest \
        golang.org/x/tools/cmd/...@latest

[[ ${UPDATE_NPM:-$UPDATE_ALL} == 1 ]] \
    && npm update -g

PYTHON=python3
[[ ${UPDATE_PIP:-$UPDATE_ALL} == 1 ]] \
    && $PYTHON -m pip list --user --outdated --format=freeze \
        | grep -v '^\-e' \
        | cut -d = -f 1 \
        | xargs -n1 $PYTHON -m pip install --upgrade

[[ ${UPDATE_POETRY:-$UPDATE_ALL} == 1 ]] \
    && poetry self update

[[ ${UPDATE_TLDR:-$UPDATE_ALL} == 1 ]] \
    && tldr --update

[[ ${UPDATE_CHEZMOI:-$UPDATE_ALL} == 1 ]] \
    && chezmoi upgrade

[[ ${UPDATE_ZINIT:-$UPDATE_ALL} == 1 ]] \
    && zsh -i -c 'zinit self-update' \
    && zsh -i -c 'zinit update'

[[ ${UPDATE_NVIM:-$UPDATE_ALL} == 1 ]] \
    && nvim +PlugInstall +PlugUpdate +UpdateRemotePlugins +qall \
    && nvim +CocUpdateSync +qall

[[ ${INSTALL_PYNVIM:-$UPDATE_ALL} == 1 ]] \
    && yarn global add neovim \
    && python3 -m pip install --user --upgrade pynvim \
    && python2 -m pip install --user --upgrade pynvim

[[ ${UPDATE_TMUX_PLUGINS:-$UPDATE_ALL} == 1 ]] \
    && ~/.tmux/plugins/tpm/bindings/update_plugins
