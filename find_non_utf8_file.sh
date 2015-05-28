#!/bin/sh

find . -type f | xargs -I {} bash -c "iconv -f utf-8 -t utf-16 {} &>/dev/null || echo {}"
