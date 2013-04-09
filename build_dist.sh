#! /bin/bash

# Script para criar um pacote de distribuição (arquivos .dvi, .pdf e .ps) do 
# documento latex.
if test $# != 1
then
    echo "Usage: $0 <project_name>"
else
    latexmk -pdfdvi -ps

    mkdir -p dist/
    tar -cjf dist/$1.tar.bz2 $1.pdf $1.dvi $1.ps
fi
