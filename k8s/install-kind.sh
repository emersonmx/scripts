#!/bin/bash

version="$(curl \
    https://api.github.com/repos/kubernetes-sigs/kind/releases/latest \
        | jq -r .name)"
tmp_binary="$(mktemp)"

echo "Installing kind $version..."
curl -Lo "$tmp_binary" "https://kind.sigs.k8s.io/dl/$version/kind-linux-amd64"
chmod +x "$tmp_binary"
mv "$tmp_binary" ~/.local/bin/kind
echo "Done."
