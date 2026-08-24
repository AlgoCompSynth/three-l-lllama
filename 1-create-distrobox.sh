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

echo "..Creating $CONTAINER_NAME"
distrobox create \
  --name $CONTAINER_NAME \
  --home $CONTAINER_HOME \
  --image $IMAGE_NAME \
  --additional-packages "libpam-systemd systemd" \
  --additional-flags "--security-opt=label=disable" \
  $NVIDIA_FLAGS \
  --init

mkdir --parents $HOME/.local/bin
export ENTRY_SCRIPT=$HOME/.local/bin/$CONTAINER_NAME
echo "..Creating command line entry script $ENTRY_SCRIPT"
echo \
  "distrobox enter $CONTAINER_NAME" \
  > $ENTRY_SCRIPT
chmod +x $ENTRY_SCRIPT

cp -rp installers options $CONTAINER_HOME
pushd $CONTAINER_HOME/installers > /dev/null

  source nvidia-smi-test.sh
  if [[ "$COMPUTE_MODE" == "CUDA" ]]
  then
    distrobox enter $CONTAINER_NAME -- ./trixie-cuda.sh

  fi

  echo "..Installing Terra from source"
  distrobox enter $CONTAINER_NAME -- ./terralang.sh

  echo "..Installing command line base"
  distrobox enter $CONTAINER_NAME -- ./command-line-base.sh

  echo "..Installing AI tools"
  distrobox enter $CONTAINER_NAME -- ./ai-tools.sh

popd > /dev/null

echo "* Finished Create Distrobox *"
echo ""
