#! /usr/bin/env -S bash -l

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/terralang.log
rm --force $LOGFILE

source set-versions.sh

export TERRA_REPO=https://github.com/terralang/terra.git
mkdir --parents $HOME/Projects
pushd $HOME/Projects > /dev/null
  echo "....Cloning terra $TERRA_VERSION"
  rm --force --recursive terra
  git clone --quiet --branch release-$TERRA_VERSION $TERRA_REPO 2>/dev/null
  cd terra/build

  echo "....Configuring terra"
  cmake -Wno-dev -Wno-author .. \
    >> $LOGFILE 2>&1

  echo "....Compiling terra"
  /usr/bin/time make -j$(nproc) \
    >> $LOGFILE 2>&1
  echo "....Installing terra"
  sudo make install \
    >> $LOGFILE 2>&1
  sudo /usr/sbin/ldconfig \
    >> $LOGFILE 2>&1
  echo "....terra installed"

  echo "....Testing terra"
  cd ../tests
  /usr/bin/time terra run \
    >> $LOGFILE 2>&1 || true
  echo "....terra tests complete"
  tail -n 10 $LOGFILE

popd > /dev/null

echo "....Finished"
echo ""
