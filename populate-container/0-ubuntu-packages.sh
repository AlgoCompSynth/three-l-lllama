#! /usr/bin/env -S bash -l

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/resolute-packages.log
rm --force $LOGFILE

export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -qqy \
  apt-file \
  build-essential \
  cmake \
  file \
  git \
  plocate \
  vim-nox \
  >> $LOGFILE 2>&1
