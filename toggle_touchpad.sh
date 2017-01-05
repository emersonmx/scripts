#!/bin/bash

value=$(xinput list-props 'SynPS/2 Synaptics TouchPad' | grep 'Device Enabled' | awk '{print $4}')
device='SynPS/2 Synaptics TouchPad'

if [ $value = 0 ]
then
    xinput enable "$device"
else
    xinput disable "$device"
fi
