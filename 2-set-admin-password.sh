#! /usr/bin/env bash

set -eu

echo "* Set Administrator Password *"

source set-host-envars

echo "..You need to set a '$USER' password to use 'sudo' in the container"
distrobox enter $CONTAINER_NAME -- sudo passwd $USER

echo "* Finished Set Administrator Password *"
echo ""
