#! /usr/bin/env bash

set -eu

echo "* Re-create Distrobox *"

source set-host-envars

echo "..Force-removing any existing $CONTAINER_NAME and $CONTAINER_HOME"
distrobox rm --force $CONTAINER_NAME
rm --recursive --force $CONTAINER_HOME

echo "..Re-creating $CONTAINER_NAME"
distrobox assemble create \
  --name $CONTAINER_NAME

echo ""
podman image list

mkdir --parents $HOME/.local/bin
export ENTRY_SCRIPT=$HOME/.local/bin/$CONTAINER_NAME
echo "..Creating command line entry script $ENTRY_SCRIPT"
echo \
  "distrobox enter $CONTAINER_NAME" \
  > $ENTRY_SCRIPT
chmod +x $ENTRY_SCRIPT

echo "* Finished Re-create Distrobox *"
echo ""
