#!/bin/bash

MANAGERS=${MANAGERS:-"arch flatpak rust cargo golang pip yarn misc"}
FORCE_INSTALL=${FORCE_INSTALL:-}

echo "Managers enabled: $MANAGERS"

function download_from_and_install_to() {
    curl -L -o $2 $1 && chmod +x $2
}

if [[ "$MANAGERS" == *"arch"* ]]
then
    yay -Syu

    [[ ! -z "$FORCE_INSTALL" ]] && yay -S \
        alacritty \
        bat \
        ccls \
        chezmoi \
        cmake \
        earlyoom \
        exa \
        fd \
        ffmpegthumbnailer \
        fzf \
        git \
        github-cli \
        go \
        go-tools \
        highlight \
        httpie \
        icat \
        jq \
        lastpass-cli \
        lld \
        neovim-remote \
        nodejs \
        noto-fonts-emoji \
        pass \
        perl-image-exiftool \
        python-cookiecutter \
        python-pip \
        python-poetry \
        python2-pip \
        qrencode \
        ranger \
        ripgrep \
        rofi \
        rofi-calc \
        rofi-emoji \
        semver \
        siji-git \
        subversion \
        tmuxp \
        trash-cli \
        ttf-fira-code \
        ttf-twemoji-color \
        vint \
        w3m \
        wmctrl \
        wmutils-git \
        xclip \
        xdotool \
        xsel \
        yapf \
        yarn \
        yq \
        ytop
fi


if [[ "$MANAGERS" == *"flatpak"* ]]
then
    if [[ ! -z "$FORCE_INSTALL" ]]
    then
        flatpak install -y \
            com.getpostman.Postman \
            com.github.tchx84.Flatseal \
            org.kde.krita \
            org.mypaint.MyPaint \
            org.kde.kdenlive
    else
        flatpak update -y
    fi
fi


if [[ "$MANAGERS" == *"rust"* ]]
then
    if [[ ! $(command -v rustup) || ! -z "$FORCE_INSTALL" ]]
    then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi

    rustup self update
    rustup update
fi


if [[ "$MANAGERS" == *"cargo"* ]]
then
    cargo install --force \
        cargo-watch \
        tealdeer
fi


if [[ "$MANAGERS" == *"golang"* ]]
then
    pkgman="go get -v -u"
    [[ ! -z "$FORCE_INSTALL" ]] && pkgman="go get -v"

    $pkgman \
        github.com/sourcegraph/go-langserver \
        github.com/mattn/efm-langserver \
        github.com/kisielk/errcheck \
        golang.org/x/lint/golint
fi


if [[ "$MANAGERS" == *"pip"* ]]
then
    pkgman="pip install --user -U"
    [[ ! -z "$FORCE_INSTALL" ]] && pkgman="pip install --user"

    $pkgman \
        gdtoolkit
fi


if [[ "$MANAGERS" == *"yarn"* ]]
then
    yarn global upgrade \
        dockerfile-language-server-nodejs \
        intelephense \
        neovim
fi


if [[ "$MANAGERS" == *"misc"* ]]
then
    download_from_and_install_to \
        https://raw.githubusercontent.com/emersonmx/scripts/master/tools/edit-config \
        $HOME/.local/bin/edit-config

    download_from_and_install_to \
        https://raw.githubusercontent.com/emersonmx/tmplt/master/tmplt \
        $HOME/.local/bin/tmplt

    zsh -i -c 'zinit self-update'
    zsh -i -c 'zinit update'

    nvim +PlugInstall +PlugUpdate +UpdateRemotePlugins +qall
    nvim +CocUpdateSync +qall
    $HOME/.tmux/plugins/tpm/scripts/update_plugin_prompt_handler.sh all

    python3 -m pip install --user --upgrade pynvim
    python2 -m pip install --user --upgrade pynvim
fi
