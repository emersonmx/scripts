FROM ubuntu:focal

RUN : \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        software-properties-common \
    && add-apt-repository --yes --update ppa:ansible/ansible \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ansible \
        sudo \
    && :

RUN useradd -s /usr/bin/bash --create-home -G sudo mauser

WORKDIR /home/mauser
