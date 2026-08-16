#! /usr/bin/env bash

set -eu

# https://apt.llvm.org/
pushd /tmp
  rm --force *.sh
  wget --quiet https://apt.llvm.org/llvm.sh
  chmod +x llvm.sh
  sudo ./llvm.sh $LLVM_VERSION all \
    >> $LOGFILE 2>&1
popd
