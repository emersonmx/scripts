#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ansible-playbook \
    -K \
    --connection=local \
    -i "$script_dir/inverntory.yaml" \
    $1
