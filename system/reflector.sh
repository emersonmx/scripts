#!/bin/bash

DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

/usr/bin/notify-send -i gtk-info "Atualizando lista de mirrors..."

reflector --verbose -c BR --latest 100 --sort rate --save /etc/pacman.d/mirrorlist

/usr/bin/notify-send -i gtk-info "Lista de mirrors atualizada!"
