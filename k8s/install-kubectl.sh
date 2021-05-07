#!/bin/bash

latest_release="$(curl -L -s https://dl.k8s.io/release/stable.txt)"
tmp_binary="$(mktemp)"

curl -Lo "$tmp_binary" "https://dl.k8s.io/release/$latest_release/bin/linux/amd64/kubectl"
chmod +x "$tmp_binary"
mv "$tmp_binary" ~/.local/bin/kubectl
