#!/bin/bash

version="$(curl -L -s https://dl.k8s.io/release/stable.txt)"
tmp_binary="$(mktemp)"

echo "Installing kubectl $version..."
curl -Lo "$tmp_binary" "https://dl.k8s.io/release/$version/bin/linux/amd64/kubectl"
chmod +x "$tmp_binary"
mv "$tmp_binary" ~/.local/bin/kubectl
echo "Done."
