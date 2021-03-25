#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y

go get -v -u \
    github.com/kisielk/errcheck \
    github.com/mattn/efm-langserver \
    github.com/sourcegraph/go-langserver \
    golang.org/x/lint/golint \
    mvdan.cc/sh/v3/cmd/shfmt \
    golang.org/x/tools/cmd/...

rustup self update
rustup update

cargo install --force \
    cargo-watch \
    exa \
    bat \
    tealdeer \
    ripgrep \
    fd-find

npm update -g

PIP=pip3
$PIP list --user --outdated --format=freeze \
    | grep -v '^\-e' \
    | cut -d = -f 1 \
    | xargs -n1 $PIP install --upgrade

tldr --update

zsh -i -c 'zinit self-update'
zsh -i -c 'zinit update'

nvim +PlugInstall +PlugUpdate +UpdateRemotePlugins +qall
nvim +CocUpdateSync +qall

python3 -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim

~/.tmux/plugins/tpm/bindings/update_plugins
