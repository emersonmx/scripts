#!/bin/bash

SINKID=$(pactl list | grep -B 1 "Name: module-jack-sink" | grep Module | \
    sed 's/[^0-9]//g')
SOURCEID=$(pactl list | grep -B 1 "Name: module-jack-source" | grep Module | \
    sed 's/[^0-9]//g')
pactl unload-module $SINKID
pactl unload-module $SOURCEID
