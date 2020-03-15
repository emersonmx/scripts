#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function godotenv() {
    if [[ $1 = 'install' ]]
    then
        output=$($script_dir/godotenv.py $*)
        for v in $(echo $output | tail -n2)
        do
            eval "export $v"
        done
    else
        $script_dir/godotenv.py $*
    fi
}
