#! /usr/bin/env bash

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/base-packages.log
rm --force $LOGFILE

source set-installer-envars

echo "....Update"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq \
  >> $LOGFILE 2>&1
echo "....Upgrade"
sudo apt-get upgrade -qqy \
  >> $LOGFILE 2>&1
echo "....Installing base packages"
sudo apt-get install -qqy \
  apt-file \
  build-essential \
  ccache \
  curl \
  file \
  git \
  gnupg \
  libcurl4-openssl-dev \
  libedit-dev \
  libpci-dev \
  libzstd-dev \
  lsb-release \
  man-db \
  ninja-build \
  nvtop \
  plocate \
  sudo \
  time \
  vim-nox \
  wget \
  xdg-utils \
  zlib1g-dev \
  >> $LOGFILE 2>&1
echo "....Base packages installed"

# https://support.mozilla.org/en-US/kb/install-firefox-linux#w_install-firefox-deb-package-for-debian-based-and-ubuntu-based-distributions-recommended

echo "....Importing signing key"
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- \
  | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc \
  > /dev/null

echo "....Adding Mozilla repository"
sudo tee /etc/apt/sources.list.d/mozilla.sources > /dev/null << EOF
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF

echo "....Prioritizing Mozilla packages"
sudo tee /etc/apt/preferences.d/mozilla > /dev/null << EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

echo "....Installing Firefox developer edition"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq >> $LOGFILE 2>&1 \
  && sudo apt-get install -qqy firefox-devedition >> $LOGFILE 2>&1

echo "....Updating search databases"
sudo apt-file update \
  >> $LOGFILE 2>&1
sudo mandb \
  >> $LOGFILE 2>&1
sudo updatedb \
  >> $LOGFILE 2>&1

echo "....Finished"
echo ""
