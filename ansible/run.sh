#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ansible-playbook \
    --ask-become-pass \
    --connection=local \
    --inventory="$script_dir/inventory.yaml" \
    $1
