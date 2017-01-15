#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

chown -R :sdkusers /opt/android-sdk/
chmod -R g+w /opt/android-sdk/
