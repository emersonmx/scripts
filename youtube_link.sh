#! /bin/bash

if [ $# != 2 ]
then
    echo "Uso: $0 <Formato> <Youtube_URL>"
    exit
fi

youtube-dl -f $1 -g --cookies=/tmp/ytcookie.txt "$2"
