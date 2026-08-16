#! /usr/bin/env -S bash -l

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/pios-packages.log
rm --force $LOGFILE

export DEBIAN_FRONTEND=noninteractive
export LLVM_VERSION=22
echo "..Installing upstream CLANG+LLVM"

echo "..Installing apt packages"
sudo apt-get install -qqy \
  apt-file \
  apt-utils \
  build-essential \
  ccache \
  clang-${LLVM_VERSION} \
  cmake \
  dialog \
  file \
  git \
  glslc \
  glslang-tools \
  libclang-${LLVM_VERSION}-dev \
  libclang-cpp${LLVM_VERSION}-dev \
  libcurl4-openssl-dev \
  libedit-dev \
  libhwloc-dev \
  libopenblas-openmp-dev \
  libopenblas64-openmp-dev \
  libpython3-dev \
  libvulkan-dev \
  libxml2-dev \
  llvm-${LLVM_VERSION}-dev \
  ninja-build \
  ocl-icd-dev \
  ocl-icd-libopencl1 \
  ocl-icd-opencl-dev \
  pkg-config \
  plocate \
  python3-dev \
  spirv-headers \
  time \
  tree \
  tmux \
  vim-nox \
  vulkan-tools \
  zlib1g-dev \
  >> $LOGFILE 2>&1
echo "..Updating apt-file database"
sudo apt-file update \
  >> $LOGFILE 2>&1
echo "..Updating locate database"
sudo updatedb \
  >> $LOGFILE 2>&1
echo "..Finished"
