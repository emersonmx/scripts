#!/bin/sh

mem=$(LC_ALL=C free  | awk '/Mem:/ {print $4}')
swap=$(LC_ALL=C free | awk '/Swap:/ {print $3}')

if [ $mem -lt $swap ]; then
    echo "ERROR: not enough RAM to write swap back, nothing done" >&2
    exit 1
fi

swapoff -a &&
swapon -a
