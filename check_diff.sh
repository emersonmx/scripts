#!/bin/bash

use_editor=

if [[ $# == 2 ]]; then
    use_editor=echo
elif [[ $# == 3 ]]; then
    use_editor=$3
else
    echo "Uso: $0 <src> <dst> [<diff_editor>]"
    exit 0
fi

IFS="
"

src=2
dest=4
grep_str='Only'
if [[ $LANG == *"pt_BR"* ]]; then
    src=3
    dest=5
    grep_str='Somente'
fi

for e in `diff -q -r "$1" "$2" | grep -v "$grep_str"`
do
    file_a=`echo $e | awk "{print $"$src"}"`
    file_b=`echo $e | awk "{print $"$dest"}"`
    $use_editor $file_a $file_b
done
