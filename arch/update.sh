#!/bin/bash

yay -Syu

rustup self update
rustup update

cargo install --force \
    cargo-watch \
    tealdeer

go get -v -u \
    github.com/sourcegraph/go-langserver \
    github.com/mattn/efm-langserver \
    github.com/kisielk/errcheck \
    golang.org/x/lint/golint

npm update -g

PIP=pip3
$PIP list --user --outdated --format=freeze \
    | grep -v '^\-e' \
    | cut -d = -f 1 \
    | xargs -n1 $PIP install --upgrade

flatpak update -y

tldr --update

zsh -i -c 'zinit self-update'
zsh -i -c 'zinit update'

nvim +PlugInstall +PlugUpdate +UpdateRemotePlugins +qall
nvim +CocUpdateSync +qall

python3 -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim

~/.tmux/plugins/tpm/bindings/update_plugins
