#!/bin/bash

use_editor=

if [[ $# == 2 ]]
then
    use_editor=echo
elif [[ $# -ge 3 ]]
then
    use_editor=${@:3}
else
    echo "Uso: $0 <source> <dest> [<diff_editor>]"
    exit 0
fi

source="$1"
dest="$2"

for f in $(find $source -follow \
    -path "*/." -prune -o \
    -path "*/.git" -prune -o \
    -follow -print \
)
do
    source_file="$(echo $f | sed 's#^\./##')"
    dest_file="$dest$source_file"

    if [[ -d $f ]]
    then
        continue
    fi
    cmp --silent $source_file $dest_file && continue

    if [[ $use_editor == 'echo' ]]
    then
        echo "$source_file <-> $dest_file"
    else
        edit="no"

        read -p "Compare files $source_file <-> $dest_file? (y/N) " yn
        case $yn in
            [Yy]* ) edit="yes"; ;;
            [Nn]* ) edit="no"; ;;
        esac

        if [[ $edit = "yes" ]]
        then
            $use_editor $source_file $dest_file
        fi
    fi
done
