#! /bin/bash

if test $# -ne 2
then
    echo "Usage: $0 <directory> <file_extension>"
else
    lines=0
    for f in `find $1 -iname $2 -type f`
    do
        loc=`wc -l $f | awk '{print $1}'`
        lines=`expr $lines + $loc`
    done

    echo Linhas: $lines
fi
