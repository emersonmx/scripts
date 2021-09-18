#!/bin/bash

top_padding="28"
current_top_padding="$(bspc config top_padding)"

if [[ "$current_top_padding" > 0 ]]
then
    bspc config top_padding 0
else
    bspc config top_padding $top_padding
fi
