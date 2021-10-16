#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

go install \
    github.com/sourcegraph/go-langserver@latest \
    github.com/mattn/efm-langserver@latest \
    github.com/kisielk/errcheck@latest \
    golang.org/x/lint/golint@latest
