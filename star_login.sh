#!/bin/bash

if [ $# != 2 ]
then
    echo "Uso: $0 <usuário> <senha>"
    exit 1
fi

curl --silent https://star.milhatelecom.com.br/logout > /dev/null
curl --silent -d "username="$1"&password="$2 \
https://star.milhatelecom.com.br/login > /dev/null
echo "Concluído!"

