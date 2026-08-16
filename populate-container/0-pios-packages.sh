#! /usr/bin/env -S bash -l

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/pios-packages.log
rm --force $LOGFILE

export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -qqy \
  apt-file \
  build-essential \
  ccache \
  cmake \
  file \
  git \
  glslc \
  glslang-tools \
  libcurl4-openssl-dev \
  libopenblas-openmp-dev \
  libopenblas64-openmp-dev \
  libvulkan-dev \
  plocate \
  spirv-headers \
  time \
  tree \
  tmux \
  vim-nox \
  vulkan-tools \
  #>> $LOGFILE 2>&1
sudo apt-file update \
  >> $LOGFILE 2>&1
sudo updatedb \
  >> $LOGFILE 2>&1
sudo apt-get install 
