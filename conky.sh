#!/bin/bash

sleep 30
conky $@ &
sleep 5
xdotool search --class "Pcmanfm" behave %@ focus windowraise $(xdotool search --class "Conky")
