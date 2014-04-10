#!/bin/bash

# Script que limpa (remove) TODOS os arquivos gerados pelo latexmk
# e do diretorio dist.
latexmk -C

rm -rf dist/
rm -f *.600pk
rm -f *.tfm
rm -f *.ilg
rm -f *.ind
rm -f *.out.ps
rm -f *.log
