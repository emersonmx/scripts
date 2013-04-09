#! /bin/bash

emerge -NDuv @world && dispatch-conf && emerge --depclean && revdep-rebuild && module-rebuild rebuild
