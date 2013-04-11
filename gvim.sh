#! /bin/bash

if [ $# -eq 1 ]
then
    cd $1
fi

[ -f .vimsession ] && gvim -S .vimsession || gvim
