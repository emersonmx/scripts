#! /bin/bash

if [ $# -eq 1 ]
then
    cd $1
fi

[ -f .vimsession ] && gvim -geometry 90x40 -S .vimsession ||
                      gvim -geometry 90x40
