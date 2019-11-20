#!/bin/bash

function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

arch_packages=(
    $(command_exists 'antibody' || echo antibody)
    $(command_exists 'bat' || echo bat)
    $(command_exists 'bear' || echo bear)
    $(command_exists 'ccls' || echo ccls)
    $(command_exists 'cmake' || echo cmake)
    $(command_exists 'composer' || echo composer)
    $(command_exists 'exa' || echo exa)
    $(command_exists 'fd' || echo fd)
    $(command_exists 'ffmpegthumbnailer' || echo ffmpegthumbnailer)
    $(command_exists 'go' || echo go)
    $(command_exists 'go-langserver' || echo go-langserver-git)
    $(command_exists 'guru' || echo go-tools)
    $(command_exists 'highlight' || echo highlight)
    $(command_exists 'http' || echo httpie)
    $(command_exists 'icat' || echo icat)
    $(command_exists 'ipython' || echo ipython)
    $(command_exists 'jq' || echo jq)
    $(command_exists 'kitty' || echo kitty)
    $(command_exists 'node' || echo nodejs)
    $(command_exists 'nvr' || echo neovim-remote)
    $(command_exists 'pass' || echo pass)
    $(command_exists 'pylint' || echo python-pylint)
    $(command_exists 'pylint2' || echo python2-pylint)
    $(command_exists 'pyls' || echo python-language-server)
    $(command_exists 'ranger' || echo ranger)
    $(command_exists 'rg' || echo ripgrep)
    $(command_exists 'w3m' || echo w3m)
    $(command_exists 'watchman' || echo watchman)
    $(command_exists 'wmctrl' || echo wmctrl)
    $(command_exists 'xclip' || echo xclip)
    $(command_exists 'xdotool' || echo xdotool)
    $(command_exists 'xsel' || echo xsel)
    $(command_exists 'yarn' || echo yarn)
)
node_packages=(
    $(command_exists 'intelephense' || echo intelephense)
    $(command_exists 'nvim' || echo neovim)
)
composer_packages=(
    $(command_exists 'php-cs-fixer' || echo friendsofphp/php-cs-fixer)
)
go_packages=(
    $(command_exists 'golint' || echo golang.org/x/lint/golint)
)

if [[ ${#arch_packages[@]} != 0 ]]
then
    echo "Installing arch packages..."
    yay -S ${arch_packages[@]}
    echo " Done."
fi

if [[ ${#node_packages[@]} != 0 ]]
then
    echo "Installing node packages..."
    yarn global add ${node_packages[@]}
    echo " Done."
fi

if [[ ${#composer_packages[@]} != 0 ]]
then
    echo "Installing composer packages..."
    composer global require ${composer_packages[@]}
    echo " Done."
fi
if [[ ${#go_packages[@]} != 0 ]]
then
    echo "Installing go packages..."
    go get -v ${go_packages[@]}
    echo " Done."
fi

# Manual commands
if ! $(command_exists 'symfony')
then
    echo 'not exists symfony'
    wget https://get.symfony.com/cli/installer -O - | sed 's/^CLI_CONFIG_DIR=.*/CLI_CONFIG_DIR=".local"/' | bash
fi
