#! /usr/bin/env bash

set -eu

echo "* Populate Container *"

source set-host-envars

cp -rp installers $CONTAINER_HOME
pushd $CONTAINER_HOME/installers > /dev/null

  source nvidia-smi-test.sh
  if [[ "$COMPUTE_MODE" == "CUDA" ]]
  then
    distrobox enter $CONTAINER_NAME -- ./trixie-cuda.sh

  fi

  echo "..Installing command line base"
  distrobox enter $CONTAINER_NAME -- ./command-line-base.sh

  echo "..Installing Terra from source"
  distrobox enter $CONTAINER_NAME -- ./terralang.sh

  echo "..Installing AI tools"
  distrobox enter $CONTAINER_NAME -- ./ai-tools.sh

popd > /dev/null

echo "* Finished Populate Container *"
echo ""
