#!/bin/bash

file_path="$1"
filename=$(echo "$file_path" | cut -f 1 -d '.')

electron "$filename.html" &

while true
do
    echo "$file_path" \
        | entr -d pandoc "$file_path" -o "$filename.html"
done
