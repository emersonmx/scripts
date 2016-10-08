#!/bin/bash

conky &
sleep 1
xdotool search --class "Pcmanfm" behave %@ focus windowraise $(xdotool search --class "Conky")
