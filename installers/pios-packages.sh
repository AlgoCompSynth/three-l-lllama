#! /usr/bin/env -S bash -l

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/pios-packages.log
rm --force $LOGFILE

export DEBIAN_FRONTEND=noninteractive
export LLVM_VERSION=22
echo "....Installing base packages"
sudo apt-get install -qqy \
  apt-file \
  build-essential \
  ccache \
  cmake \
  file \
  git \
  glslang-tools \
  glslc \
  libcurl4-openssl-dev \
  libedit-dev \
  libopenblas64-openmp-dev \
  libopenblas-openmp-dev \
  libvulkan-dev \
  libzstd-dev \
  lsb-release \
  plocate \
  spirv-headers \
  time \
  vim-nox \
  vulkan-tools \
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
  echo "....LLVM installed"

popd > /dev/null

echo "....Updating search databases"
sudo apt-file update \
  >> $LOGFILE 2>&1
sudo updatedb \
  >> $LOGFILE 2>&1
echo "....Finished"
