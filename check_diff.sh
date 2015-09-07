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

for e in `diff -q -r $1 $2 | grep -v Only`
do
    file_a=`echo $e | awk '{print $2}'`
    file_b=`echo $e | awk '{print $4}'`
    $use_editor $file_a $file_b
done
