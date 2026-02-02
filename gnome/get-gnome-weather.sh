#!/usr/bin/env bash

language=$(locale | sed -n 's/^LANG=\([^_]*\).*/\1/p')

if [[ ! -z "$*" ]]; then
    query="$*"
else
    read -r -p "Type the name of the location you want to add to GNOME Weather: " query
fi

query="${query// /+}"

request=$(curl "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1" -H "Accept-Language: $language" -s)

if [[ $request == "[]" ]]; then
    echo "No locations found, consider removing some search terms"
    exit
fi

echo "$request" | sed 's/.*"display_name":"//' | sed 's/".*//'

name=$(echo "$request" | sed 's/.*"name":"//' | sed 's/".*//')

lat=$(echo "$request" | sed 's/.*"lat":"//' | sed 's/".*//')
lat=$(echo "$lat / (180 / 3.141592654)" | bc -l)

lon=$(echo "$request" | sed 's/.*"lon":"//' | sed 's/".*//')
lon=$(echo "$lon / (180 / 3.141592654)" | bc -l)

location="<(uint32 2, <('$name', '', false, [($lat, $lon)], @a(dd) [])>)>"
echo "Add to org.gnome.Weather locations"
echo "[$location]"
