#! /usr/bin/env -S bash -l

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/llama-cpp.log
rm --force $LOGFILE

mkdir --parents $HOME/.local/bin

#echo "....Activating Homebrew PATH"
#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

#echo "....Installing Pi coding agent"
#brew install --yes --quiet \
  #pi-coding-agent \
  #>> $LOGFILE 2>&1

#echo "....Cleaning up"
#brew cleanup --prune all --scrub --quiet \
  #>> $LOGFILE 2>&1

#echo "....Installing pi-llama plugin"
#pi install git:github.com/huggingface/pi-llama

# https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md
export LLAMA_CPP_VERSION=b10453
export LLAMA_CPP_REPO=https://github.com/ggml-org/llama.cpp
#export CUDACXX=/usr/local/cuda-13.3/bin/nvcc
mkdir --parents $HOME/Projects
pushd $HOME/Projects > /dev/null
  echo "....Cloning llama.cpp $LLAMA_CPP_VERSION"
  rm --force --recursive llama.cpp
  git clone --quiet --branch $LLAMA_CPP_VERSION $LLAMA_CPP_REPO 2>/dev/null
  cd llama.cpp

  echo "....Configuring llama.cpp"
  #cmake -B build -DGGML_CUDA=ON \
  cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS -DGGML_VULKAN=1 \
    #>> $LOGFILE 2>&1

  echo "....Compiling llama.cpp"
  /usr/bin/time cmake --build build --config Release -j$(nproc) \
    #>> $LOGFILE 2>&1
  echo "....Installing llama.cpp"
  sudo cmake --install build \
    #>> $LOGFILE 2>&1
  sudo /usr/sbin/ldconfig --verbose \
    #>> $LOGFILE 2>&1
  echo "....llama.cpp installed"

popd > /dev/null
