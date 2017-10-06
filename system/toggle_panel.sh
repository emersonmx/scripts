#!/bin/bash

panel='panel-1'

set_panel_autohide_behavior() {
    xfconf-query -c xfce4-panel -p "/panels/$panel/autohide-behavior" -s $1
}
value=$(xfconf-query -c xfce4-panel -p "/panels/$panel/autohide-behavior")
if [[ value -eq 0 ]]; then
    set_panel_autohide_behavior 2
else
    set_panel_autohide_behavior 1
    set_panel_autohide_behavior 0
fi
