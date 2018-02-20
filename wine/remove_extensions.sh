#!/bin/bash

find ~/.local/share -name "*wine*" | xargs --no-run-if-empty rm -r

update-desktop-database ~/.local/share/applications
update-mime-database ~/.local/share/mime/
