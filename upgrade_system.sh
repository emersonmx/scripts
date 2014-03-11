#! /bin/bash

emerge -NDuv @world \
    --buildpkg --buildpkg-exclude "virtual/* sys-kernel/*-sources"
emerge -v @preserved-rebuild
emerge --depclean
revdep-rebuild
emerge @module-rebuild
dispatch-conf

