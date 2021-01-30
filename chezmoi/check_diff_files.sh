#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

managed_files=$(chezmoi managed)

for f in $managed_files
do
    if [[ ! -f $f ]]
    then
        continue
    fi

    if [[ -z $(chezmoi diff $f) ]]
    then
        continue
    fi

    read -p "You want to merge the file \"$f\"? (y/N) " merge_file

    [[ -n $merge_file ]] && chezmoi merge $f
done
