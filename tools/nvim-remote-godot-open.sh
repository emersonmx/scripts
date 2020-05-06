#!/bin/bash

if [[ $# != 2 ]]
then
    echo "Usage: $0 <project_path> <file_path>"
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

project_path="$1"
file_path="$2"

(cd $project_path && $script_dir/nvim-remote-open.sh "+e $file_path")
