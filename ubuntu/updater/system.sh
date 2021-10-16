#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt-get update -y
sudo apt-get upgrade -y

sudo -k
