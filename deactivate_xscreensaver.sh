#!/bin/bash

while [[ true ]]; do
    echo "Tick"
    xscreensaver-command -deactivate >&- 2>&- &
    sleep 30
done
