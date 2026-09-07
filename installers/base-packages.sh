#! /bin/bash -l

set -eu

source set-installer-envars
export LOGFILE=$HOME/Logfiles/base-packages.log
rm --force $LOGFILE

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
  bash \
  build-essential \
  ccache \
  cmake \
  curl \
  file \
  git \
  gnupg \
  libcurl4-openssl-dev \
  libedit-dev \
  libzstd-dev \
  lsb-release \
  man-db \
  nvtop \
  plocate \
  sudo \
  time \
  tree \
  vim-nox \
  wget \
  xdg-utils \
  zlib1g-dev \
  >> $LOGFILE 2>&1
echo "....Base packages installed"
echo "....Finished"
echo ""
