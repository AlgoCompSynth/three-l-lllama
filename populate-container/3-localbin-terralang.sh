#! /usr/bin/env -S bash -l

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/localbin-terralang.log
rm --force $LOGFILE

#echo "....Activating Homebrew PATH"
#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

mkdir --parents $HOME/.local/bin

# https://github.com/terralang/llvm-build
export LLVM_VERSION=22.1.8
export LLVM_TARBALL=clang+llvm-$LLVM_VERSION-$ARCH-linux-gnu.tar.xz
export LLVM_URL=https://github.com/terralang/llvm-build/releases/download/llvm-$LLVM_VERSION/$LLVM_TARBALL
echo "....Installing clang-llvm $LLVM_VERSION tarball"
curl -sL \
  $LLVM_URL \
  | tar xJf - --directory=$HOME/.local --strip-components=1
echo "....clang-llvm  installed"

export TERRA_VERSION=1.2.2
export TERRA_REPO=https://github.com/terralang/terra.git
mkdir --parents $HOME/Projects
pushd $HOME/Projects > /dev/null
  echo "....Cloning terra $TERRA_VERSION"
  rm --force --recursive terra
  git clone --quiet --branch release-$TERRA_VERSION $TERRA_REPO 2>/dev/null
  cd terra/build

  echo "....Configuring terra"
  cmake -Wno-dev -Wno-author -DCMAKE_INSTALL_PREFIX=$HOME/.local .. \
    >> $LOGFILE 2>&1

  echo "....Compiling and installing terra"
  /usr/bin/time make install -j$(nproc) \
    >> $LOGFILE 2>&1
  echo "....terra installed"

  echo "....Testing terra"
  cd ../tests
  /usr/bin/time terra run \
    >> $LOGFILE 2>&1 || true
  echo "....terra tests complete"
  tail -n 10 $LOGFILE

popd > /dev/null
