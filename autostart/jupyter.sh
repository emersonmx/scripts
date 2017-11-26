#!/bin/bash

basedir=$(dirname "$0")
abspath=$(realpath "$basedir")
source "$abspath/utils.sh"

icon="$abspath/icons/jupyter.png"

is_running "jupyter-notebook"
if [ $? -eq 1 ]
then
    exit
fi

notify-send 'Jupyter' 'Waiting for chromium...' -i "$icon"
wait_for chromium

notify-send 'Jupyter' 'Starting...' -i "$icon"

cd /home/emersonmx/Documents/notebooks
jupyter notebook &
