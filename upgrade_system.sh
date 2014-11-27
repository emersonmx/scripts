#!/bin/bash

export SOLARIZED="true"

echo "Baixando atualizações"
eix-sync

#echo "Montando /var/tmp/portage na RAM"
#umount /var/tmp/portage
#mount -t tmpfs -o size=2048M,nr_inodes=1M tmpfs /var/tmp/portage

echo "Atualizando o sistema"
emerge -NDuv @world &&
emerge -v @preserved-rebuild &&
emerge --depclean &&
revdep-rebuild &&
emerge @module-rebuild &&
dispatch-conf

#echo "Desmontando /var/tmp/portage"
#umount /var/tmp/portage
