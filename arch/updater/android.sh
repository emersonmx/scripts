#!/usr/bin/env bash

if command -v android &>/dev/null; then
    android update
else
    curl -fsSL https://dl.google.com/android/cli/latest/linux_x86_64/install.sh | bash
fi
