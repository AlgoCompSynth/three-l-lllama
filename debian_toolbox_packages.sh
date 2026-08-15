#! /usr/bin/env bash

set -eu

export DEBIAN_FRONTEND=noninteractive
echo "....Installing Debian toolbox packages"
sudo apt-get update -qq
sudo cp locale.gen /etc
sudo /usr/sbin/locale-gen
sudo apt-get full-upgrade -qqy
sudo apt-get install -qqy \
  apt-file \
  build-essential \
  neovim \
  plocate \
  ripgrep \
  time \
  tmux \
  tree
sudo apt-file update
sudo updatedb
