#! /usr/bin/env bash

set -eu

export DEBIAN_FRONTEND=noninteractive
echo "....Installing Debian host packages"
sudo apt-get install -qqy \
  podman-toolbox
