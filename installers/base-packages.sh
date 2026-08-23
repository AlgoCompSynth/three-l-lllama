#! /usr/bin/env bash

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/base-packages.log
rm --force $LOGFILE

source set-installer-envars

export MACHINE=$(uname --machine)
export CMAKE_TARBALL=cmake-$CMAKE_VERSION-linux-$MACHINE.tar.gz
export CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/$CMAKE_TARBALL

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
  clinfo \
  clpeak \
  curl \
  file \
  firefox-esr \
  git \
  glslang-tools \
  glslc \
  gnupg \
  libcurl4-openssl-dev \
  libedit-dev \
  libopenblas64-openmp-dev \
  libopenblas-openmp-dev \
  libpci-dev \
  libvulkan-dev \
  libzstd-dev \
  lsb-release \
  man-db \
  ninja-build \
  plocate \
  pocl-opencl-icd \
  spirv-headers \
  sudo \
  time \
  vim-nox \
  vulkan-tools \
  wget \
  zlib1g-dev \
  >> $LOGFILE 2>&1
echo "....Base packages installed"

pushd /tmp > /dev/null
  echo "....Installing LLVM $LLVM_VERSION"
  rm --force *.sh
  wget --quiet https://apt.llvm.org/llvm.sh
  chmod +x llvm.sh
  sudo ./llvm.sh $LLVM_VERSION all \
    >> $LOGFILE 2>&1
  sudo apt-get install -qqy \
    clang-22-doc \
    libomp-22-doc \
    llvm-22-doc \
    >> $LOGFILE 2>&1
  echo "....LLVM installed"

  echo "....Installing CMake $CMAKE_VERSION"
  rm --force *.gz
  echo "....Downloading $CMAKE_URL"
  wget --quiet $CMAKE_URL
  echo "....Unpacking $CMAKE_TARBALL to /usr/local"
  sudo tar xvf $CMAKE_TARBALL --directory=/usr/local --strip-components=1 \
    >> $LOGFILE 2>&1
  echo "....Updating shared library tables"
  sudo /usr/sbin/ldconfig \
    >> $LOGFILE 2>&1
  echo "....CMake installed"

popd > /dev/null

echo "....Updating search databases"
sudo apt-file update \
  >> $LOGFILE 2>&1
sudo mandb \
  >> $LOGFILE 2>&1
sudo updatedb \
  >> $LOGFILE 2>&1

echo "....Finished"
echo ""
