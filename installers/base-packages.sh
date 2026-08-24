#! /usr/bin/env bash

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/base-packages.log
rm --force $LOGFILE

source set-installer-envars

echo "....Computing download URLs"
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
  xdg-utils \
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
