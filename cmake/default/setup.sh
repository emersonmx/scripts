#!/bin/bash

echo 'Creating project...'
mkdir -p 'build/'
mkdir -p 'cmake/'
mkdir -p 'cmake/Modules/'
mkdir -p 'include/'
mkdir -p 'src/'
mkdir -p 'test/'
touch CMakeLists.txt

echo 'Linking compile_commands.json...'
ln -sf build/compile_commands.json

echo 'Done.'
