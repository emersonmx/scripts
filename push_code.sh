#!/bin/bash

code_dir="$HOME/code"
download_dirs="dotfiles my_arch_config scripts"

pushd $code_dir > /dev/null
for dir in $download_dirs
do
    echo "- Pushing repository $dir... -"
    pushd $dir > /dev/null
    git push
    popd > /dev/null
    echo "- Pushing repository $dir done. -"
done
popd > /dev/null
