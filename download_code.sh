#!/bin/bash

code_dir="$HOME/code"
download_dirs="dotfiles/ my_arch_config/ scripts/"

pushd $code_dir > /dev/null
for dir in $download_dirs
do
    echo "Updating $dir..."
    pushd $dir > /dev/null
    git fetch
    popd > /dev/null
    echo "Updating $dir done."
done
popd > /dev/null
