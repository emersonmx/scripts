#!/bin/bash

latest_release="$(curl \
    https://api.github.com/repos/kubernetes-sigs/kind/releases/latest \
        | jq -r .name)"
tmp_binary="$(mktemp)"

curl -Lo "$tmp_binary" "https://kind.sigs.k8s.io/dl/$latest_release/kind-linux-amd64"
chmod +x "$tmp_binary"
mv "$tmp_binary" ~/.local/bin/kind
