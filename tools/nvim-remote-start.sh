#!/bin/bash

socket_id="$(printf "%s" $PWD | sha1sum | cut -d' ' -f1)"

NVIM_LISTEN_ADDRESS="/tmp/nvim-remote-$socket_id" nvim $@
