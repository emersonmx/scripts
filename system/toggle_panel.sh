#!/bin/bash

panel='panel-1'

function panel_autohide_behavior() {
    xfconf-query -c xfce4-panel -p "/panels/$panel/autohide-behavior" $@
}

value=$(panel_autohide_behavior)
if [[ value -eq 0 ]]
then
    panel_autohide_behavior -s 2
else
    panel_autohide_behavior -s 0
fi
