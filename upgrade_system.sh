#! /bin/bash

emerge -NDuv @world &&
emerge -v @preserved-rebuild &&
emerge --depclean &&
revdep-rebuild &&
module-rebuild rebuild &&
dispatch-conf

