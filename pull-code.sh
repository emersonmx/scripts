#!/bin/bash

code_dir="$HOME/code"
download_dirs="dotfiles my-arch-config phpd scripts"

pushd $code_dir > /dev/null
for dir in $download_dirs
do
    echo "- Fetching repository $dir... -"
    pushd $dir > /dev/null
    git pull
    popd > /dev/null
    echo "- Fetching repository $dir done. -"
done
popd > /dev/null