#!/usr/bin/env bash

if command -v pnpm &>/dev/null; then
    pnpm self-update
else
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

sed '/^# pnpm$/,/^# pnpm end$/d' -i ~/.zshrc

pnpm completion zsh >~/.cache/zsh/completions/_pnpm
