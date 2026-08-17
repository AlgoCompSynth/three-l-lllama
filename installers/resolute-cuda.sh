#! /usr/bin/env -S bash -l

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/install-cuda.log
rm --force $LOGFILE

# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu
echo "....Installing CUDA toolkit"
pushd /tmp > /dev/null
  rm --force *.deb
  wget --quiet \
    https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2604/x86_64/cuda-keyring_1.1-1_all.deb
  sudo dpkg -i cuda-keyring_1.1-1_all.deb \
    >> $LOGFILE 2>&1
  sudo apt-get update \
    >> $LOGFILE 2>&1
  sudo apt-get -y install cuda-toolkit-13-3 \
    >> $LOGFILE 2>&1

popd > /dev/null
echo "....CUDA toolkit is installed"
