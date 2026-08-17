#! /usr/bin/env bash

set -eu

echo "* Populate Container *"

source set-host-envars

cp -rp installers $CONTAINER_HOME
pushd $CONTAINER_HOME/installers > /dev/null

  echo "..Installing apt packages"
  distrobox enter $CONTAINER_NAME -- ./trixie-packages.sh

  if [[ "$COMPUTE_MODE" == "CUDA" ]]
  then
    distrobox enter $CONTAINER_NAME -- ./trixie-cuda.sh

  fi

  echo "..Installing llama.cpp"
  distrobox enter $CONTAINER_NAME -- ./llama-cpp.sh

  echo "..Installing Terra"
  distrobox enter $CONTAINER_NAME -- ./terralang.sh

  echo "..Installing Homebrew command line"
  distrobox enter $CONTAINER_NAME -- ./homebrew-command-line.sh

popd > /dev/null

echo ""
podman image list

echo "* Finished Populate Container *"
echo ""
