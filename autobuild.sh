#!/bin/bash

# Se houver mais de 1 arquivos .tex no diretório de execução, o latexmk não vai
# saber o que fazer. Se for seu caso, você deve especificar o arquivo a ser
# construido.
latexmk -pvc -view=none -pdf # arquivo.tex
