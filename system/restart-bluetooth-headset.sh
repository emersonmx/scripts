#!/bin/bash

systemctl restart bluetooth
sleep 3
echo 'connect 04:FE:A1:4F:26:9F' | bluetoothctl
