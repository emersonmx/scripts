#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install \
    gcc make \
    pkg-config autoconf automake \
    python3-docutils \
    libseccomp-dev \
    libjansson-dev \
    libyaml-dev \
    libxml2-dev

rm -rf /tmp/packages/ctags
git clone https://github.com/universal-ctags/ctags.git /tmp/packages/ctags
cd /tmp/packages/ctags

./autogen.sh
./configure --prefix=$HOME/.local
make
make install
