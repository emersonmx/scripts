#!/usr/bin/env bash

if command -v claude &>/dev/null; then
    claude update
else
    curl -fsSL https://claude.ai/install.sh | bash
fi
