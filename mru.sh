#!/bin/bash

find $1 -type f -iname $2 | xargs stat --format "%Y %n" | sort -nr | cut -d ' ' -f2-
