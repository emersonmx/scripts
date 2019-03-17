#!/bin/bash

headset_name="EDIFIER"
headset_mac="$(echo 'devices' | bluetoothctl | sed -r -e '/Device/ !d' -e 's/Device ([0-9A-F:]*).*'$headset_name'.*/\1/')"
headset_connected="$(echo "info $headset_mac" | bluetoothctl | sed -r -e '/Connected:/ !d' -e 's/.*Connected: (.*)/\1/')"

if [[ $headset_connected == 'yes' ]]
then
    echo "disconnect $headset_mac" | bluetoothctl
    notify-send "Desconectando Headset..."
else
    echo "connect $headset_mac" | bluetoothctl
    notify-send "Conectando Headset..."
fi
