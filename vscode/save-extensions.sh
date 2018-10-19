#!/usr/bin/env bash

code --list-extensions 2> /dev/null | xargs -L 1 echo code --install-extension
