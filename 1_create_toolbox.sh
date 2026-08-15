#! /usr/bin/env bash

set -eu

echo "* Create Toolbox *"

source set-host-envars

if [[ $OS_ID == "debian" ]]

then
  ./debian_host_packages.sh

  tool
  echo "..Creating toolbox"
  toolbox --assumeyes create
  toolbox run ./debian_toolbox_packages.sh

else
  echo "Unsupported OS!"
  exit -255

fi

echo "* Finished Create Toolbox *"
echo ""
