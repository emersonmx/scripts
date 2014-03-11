#! /bin/bash

if [ $# != 1 ]
then
    echo "Uso: $0 <Youtube_URL>"
    exit
fi

youtube-dl -F "$1"
