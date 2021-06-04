#!/bin/bash

export K3D_INSTALL_DIR="$USER_LOCAL/bin"
export USE_SUDO="false"
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
