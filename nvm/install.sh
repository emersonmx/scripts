#!/bin/bash

latest_nvm_version=$( \
    curl --silent \
        'https://api.github.com/repos/nvm-sh/nvm/releases/latest' \
        -H 'Accept: application/vnd.github.v3+json' \
    | grep '"tag_name"' \
    | sed -E 's/.*"([^"]+)".*/\1/' \
)
curl -o- \
    "https://raw.githubusercontent.com/nvm-sh/nvm/$latest_nvm_version/install.sh" \
    | PROFILE=/dev/null bash

