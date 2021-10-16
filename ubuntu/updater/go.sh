#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

go install \
    github.com/kisielk/errcheck@latest \
    github.com/mattn/efm-langserver@latest \
    github.com/sourcegraph/go-langserver@latest \
    golang.org/x/lint/golint@latest \
    mvdan.cc/sh/v3/cmd/shfmt@latest \
    golang.org/x/tools/cmd/...@latest
