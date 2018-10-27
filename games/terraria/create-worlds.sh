#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo -n 'Digite um prefixo: '
read prefix

echo -n 'Digite a quantidade de mundos: '
read worlds_length

for i in $(seq "$worlds_length")
do
    echo "Criando o mundo \"$prefix$i\""
    echo exit-nosave | ./TerrariaServer -port 7799 -maxplayers 1 -autocreate 1 -worldname "$prefix$i" -world "$prefix$i.wld" -noupnp
    echo "Mundo \"$prefix$i\" criado!"
done
