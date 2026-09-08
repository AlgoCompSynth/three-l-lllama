#! /bin/bash -l

set -eu

source set-installer-envars
export LOGFILE=$HOME/Logfiles/terralang.log
rm --force $LOGFILE

echo "....Prepending $LLVM_PATH to PATH"
export PATH=$LLVM_PATH:$PATH

pushd $HOME/Projects > /dev/null
  echo "....Cloning terra $TERRA_VERSION"
  rm --force --recursive terra
  git clone --quiet --branch release-$TERRA_VERSION $TERRA_REPO 2>/dev/null
  cd terra/build

  echo "....Configuring terra"
  cmake -Wno-author .. \
    >> $LOGFILE 2>&1

  echo "....Compiling terra"
  /usr/bin/time make -j$(nproc) \
    >> $LOGFILE 2>&1
  echo "....Installing terra"
  sudo make install \
    >> $LOGFILE 2>&1
  sudo /sbin/ldconfig \
    >> $LOGFILE 2>&1
  echo "....terra installed"

  echo "....Testing terra"
  cd ../tests
  /usr/bin/time terra run \
    >> $LOGFILE 2>&1 || true
  echo "....terra tests complete"
  tail -n 4 $LOGFILE
  echo ""

popd > /dev/null

echo "....Finished"
echo ""
