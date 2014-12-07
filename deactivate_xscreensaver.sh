#!/bin/bash

while [[ true ]]; do
    xscreensaver-command -deactivate >&- 2>&- &
    sleep 30
done
