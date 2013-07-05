#! /bin/bash

emerge -NDuv @world
emerge --depclean
revdep-rebuild
module-rebuild rebuild
dispatch-conf

