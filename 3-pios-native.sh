#! /usr/bin/env bash

set -eu

echo "* Raspberry Pi OS Install *"

source set-host-envars

pushd populate-container

  echo "..Installing apt packages"
  ./0-pios-packages.sh

  echo "..Installing Homebrew"
  ./1-install-homebrew.sh

  echo "..Installing command line utilities"
  ./2-brew-command-line.sh

  echo "..Installing LLVM & Terra"
  ./3-localbin-terralang.sh

  echo "..Installing llama.cpp"
  ./4-llama-cpp.sh

popd

echo "* Finished Raspberry Pi OS Install *"
echo ""
