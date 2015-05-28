#!/bin/bash

if [[ $# != 1 ]]; then
    echo "Usage: $0 <project>"
    exit 1
fi

mkdir -p $1
cd $1
mkdir -p $1
mkdir -p build/
touch CMakeLists.txt
