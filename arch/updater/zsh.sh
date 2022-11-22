#!/bin/bash

for d in $(ls $HOME/.config/zsh)
do
    pushd "$HOME/.config/zsh/$d" > /dev/null
    git pull origin HEAD
    popd > /dev/null
done
