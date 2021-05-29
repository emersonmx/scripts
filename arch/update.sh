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
    && rustup self update \
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
    && [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" \
    && nvm use default \
    && npm update -g

function get_python_version() {
    semver -r $1 $(pyenv install --list) | tail -n1
}

DEFAULT_PYTHON_VERSION="~3.9"
PYTHON_VERSIONS=('~2.7' $DEFAULT_PYTHON_VERSION)
[[ ${UPDATE_PYENV:-$UPDATE_ALL} == 1 ]] \
    && (cd $PYENV_ROOT && git pull) \
    && for v in ${PYTHON_VERSIONS[@]}
       do
           full_version=$(get_python_version $v)
           pyenv install -s $full_version
           if [[ $full_version == "$DEFAULT_PYTHON_VERSION" ]]
           then
               (cd $HOME && pyenv local $full_version)
           fi
       done

PIP=pip3
[[ ${UPDATE_PIP:-$UPDATE_ALL} == 1 ]] \
    && $PIP list --user --outdated --format=freeze \
        | grep -v '^\-e' \
        | cut -d = -f 1 \
        | xargs -n1 $PIP install --upgrade

[[ ${UPDATE_FLATPAK:-$UPDATE_ALL} == 1 ]] \
    && flatpak update -y

[[ ${UPDATE_TLDR:-$UPDATE_ALL} == 1 ]] \
    && tldr --update

[[ ${UPDATE_ZINIT:-$UPDATE_ALL} == 1 ]] \
    && zsh -i -c 'zinit self-update' \
    && zsh -i -c 'zinit update'

[[ ${UPDATE_NVIM:-$UPDATE_ALL} == 1 ]] \
    && nvim +PlugInstall +PlugUpdate +UpdateRemotePlugins +qall \
    && nvim +CocUpdateSync +qall

[[ ${INSTALL_PYNVIM:-$UPDATE_ALL} == 1 ]] \
    && python3 -m pip install --user --upgrade pynvim \
    && python2 -m pip install --user --upgrade pynvim

[[ ${UPDATE_TMUX_PLUGINS:-$UPDATE_ALL} == 1 ]] \
    && ~/.tmux/plugins/tpm/bindings/update_plugins
