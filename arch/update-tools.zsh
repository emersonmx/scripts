#!/bin/zsh

script_dir="$(cd "$(dirname "$0")" && pwd)"

pushd "$script_dir/.."

source ~/.zshrc

antibody bundle < zsh/plugins.txt > zsh/plugins.zsh
antibody update
(cd ~/.config/base16-shell && git pull origin master)
composer global update
wget https://get.symfony.com/cli/installer -O - | sed 's/^CLI_CONFIG_DIR=.*/CLI_CONFIG_DIR=".local"/' | bash
nvim +PlugUpdate +UpdateRemotePlugins +qall
nvim +CocUpdateSync +qall
nvim +PythonSupportInitPython2 +PythonSupportInitPython3 +qall
$HOME/.config/tmux/plugins/tpm/bindings/update_plugins

popd
