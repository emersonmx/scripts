#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

UPDATE_ALL=${UPDATE_ALL:-1}

_old_path="$PATH"
export PATH=$(echo $PATH | sed "s#$USER_LOCAL/bin:##")

[[ ${UPDATE_MIRRORLIST:-$UPDATE_ALL} == 1 ]] \
    && sudo $script_dir/reflector.sh

[[ ${UPDATE_SYSTEM:-$UPDATE_ALL} == 1 ]] \
    && yay -Syu

sudo -k

export PATH="$_old_path"

[[ ${UPDATE_RUST:-$UPDATE_ALL} == 1 ]] \
    && rustup update

[[ ${UPDATE_CARGO:-$UPDATE_ALL} == 1 ]] \
    && cargo install --force \
        cargo-watch \
        tealdeer

[[ ${UPDATE_GO:-$UPDATE_ALL} == 1 ]] \
    && go get -v -u \
        github.com/sourcegraph/go-langserver \
        github.com/mattn/efm-langserver \
        github.com/kisielk/errcheck \
        golang.org/x/lint/golint

[[ ${UPDATE_NPM:-$UPDATE_ALL} == 1 ]] \
    && npm update -g

PYTHON=python3
[[ ${UPDATE_PIP:-$UPDATE_ALL} == 1 ]] \
    && $PYTHON -m pip list --user --outdated --format=freeze \
        | grep -v '^\-e' \
        | cut -d = -f 1 \
        | xargs -n1 $PYTHON -m pip install --upgrade

[[ ${UPDATE_VIRTUALENV:-$UPDATE_ALL} == 1 ]] \
    && ( \
        tmp_bin="$(mktemp)" \
        && virtualenv_path="$USER_LOCAL/bin/virtualenv" \
        && curl --location --output "$tmp_bin" https://bootstrap.pypa.io/virtualenv.pyz  \
        && echo '#!/usr/bin/env python' > "$virtualenv_path" \
        && cat "$tmp_bin" >> "$virtualenv_path" \
        && chmod +x "$virtualenv_path" \
    )

[[ ${UPDATE_TLDR:-$UPDATE_ALL} == 1 ]] \
    && tldr --update

[[ ${UPDATE_CHEZMOI:-$UPDATE_ALL} == 1 ]] \
    && chezmoi upgrade

[[ ${UPDATE_ZINIT:-$UPDATE_ALL} == 1 ]] \
    && zsh -i -c 'zinit self-update' \
    && zsh -i -c 'zinit update'

[[ ${UPDATE_NVIM:-$UPDATE_ALL} == 1 ]] \
    && yarn global add neovim \
    && nvim +PlugInstall +PlugUpdate +UpdateRemotePlugins +qall \
    && nvim +CocUpdateSync +qall

[[ ${INSTALL_PYNVIM:-$UPDATE_ALL} == 1 ]] \
    && python3 -m pip install --user --upgrade pynvim \
    && python2 -m pip install --user --upgrade pynvim

[[ ${UPDATE_TMUX_PLUGINS:-$UPDATE_ALL} == 1 ]] \
    && ~/.tmux/plugins/tpm/bindings/update_plugins
