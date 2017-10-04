#!/bin/bash

sudo systemctl start warsaw \
    && read && sudo systemctl stop warsaw \
    && sudo systemctl status warsaw
