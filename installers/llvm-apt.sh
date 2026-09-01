#! /usr/bin/env bash

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/apt-llvm.log
rm --force $LOGFILE

source set-installer-envars

export DEBIAN_FRONTEND=noninteractive
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

popd > /dev/null

echo "....Finished"
echo ""
