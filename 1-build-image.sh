#! /usr/bin/env bash

set -eu

echo "* Build Image *"

source set-host-envars

echo "..Building base image"
podman image build \
  --compress \
  --env ADMIN_USER=$USER \
  --file Containerfile \
  --tag $IMAGE_NAME \
  $NVIDIA_FLAGS \
  $SECURITY_FLAGS \
  --squash-all \
  .

echo ""
podman image list

echo "* Finished Build Image *"
echo ""
