#! /usr/bin/env bash

set -eu

echo "* Raspberry Pi OS Install *"

source set-host-envars

pushd installers > /dev/null

  echo "..Installing apt packages"
  ./pios-packages.sh

  echo "..Installing llama.cpp"
  ./llama-cpp.sh

  echo "..Installing Terra"
  ./terralang.sh

  echo "..Installing Homebrew command line"
  ./homebrew-command-line.sh

popd > /dev/null

echo "* Finished Raspberry Pi OS Install *"
echo ""
