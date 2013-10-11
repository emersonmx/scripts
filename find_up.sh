#!/bin/bash

set -e
path="$1"
shift 1

while [[ "`readlink -f $path`" != "/" ]];
do
    find "$path"  -maxdepth 1 -mindepth 1 "$@"
    path=${path}/..
done

