#! /usr/bin/env bash

set -eu

echo "* Populate Container *"

source set-host-envars

cp -rp populate-container $CONTAINER_HOME
pushd $CONTAINER_HOME/populate-container > /dev/null

  echo "..Installing Ubuntu packages"
  distrobox enter $CONTAINER_NAME -- ./0-ubuntu-packages.sh

  echo "..Installing Homebrew"
  distrobox enter $CONTAINER_NAME -- ./1-install-homebrew.sh

  echo "..Installing command line utilities"
  distrobox enter $CONTAINER_NAME -- ./2-brew-command-line.sh

  echo "..Installing LLVM & Terra"
  distrobox enter $CONTAINER_NAME -- ./3-localbin-terralang.sh

popd > /dev/null

echo ""
podman image list

echo "* Finished Populate Container *"
echo ""
