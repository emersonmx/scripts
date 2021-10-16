#!/bin/bash

nvim +PlugInstall +PlugUpdate +UpdateRemotePlugins +qall
nvim +CocUpdateSync +qall
