#!/bin/zsh

script_dir="$(cd "$(dirname "$0")" && pwd)"

pushd "$script_dir/.."

source ~/.zshrc

zplugin self-update
(cd ~/.config/base16-shell && git pull origin master)
composer global update
symfony self:update
nvim +PlugInstall +PlugUpdate +UpdateRemotePlugins +qall
nvim +CocUpdateSync +qall
nvim +PythonSupportInitPython2 +PythonSupportInitPython3 +qall
$HOME/.config/tmux/plugins/tpm/bindings/update_plugins

popd
