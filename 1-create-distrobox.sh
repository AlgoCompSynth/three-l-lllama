#! /usr/bin/env bash

set -eu

echo "* Create Distrobox *"

source set-host-envars

if [[ "$(distrobox list 2>/dev/null | grep "$CONTAINER_NAME" | wc -l)" -gt "0" ]]
then
  echo "..$CONTAINER_NAME already exists - exiting"
  exit 0

fi

echo "..Building base image"
podman image build \
  --file Containerfile \
  --format docker \
  --tag $IMAGE_NAME \
  --squash-all \
  .

echo ""
podman image list

echo "..Creating $CONTAINER_NAME"
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

echo "* Finished Create Distrobox *"
echo ""
