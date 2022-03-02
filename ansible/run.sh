#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ansible-playbook \
    -K \
    --connection=docker \
    -i "$script_dir/inventory.yaml" \
    $1
