#!/usr/bin/env bash

curl -fsSL https://get.pnpm.io/install.sh | sh -

sed '/^# pnpm$/,/^# pnpm end$/d' -i ~/.zshrc
