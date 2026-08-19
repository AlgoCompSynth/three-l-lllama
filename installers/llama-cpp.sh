#! /usr/bin/env -S bash -l

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/llama-cpp.log
rm --force $LOGFILE

source set-versions.sh
source nvidia-smi-test.sh

# https://aicompetence.org/running-llama-on-raspberry-pi-5/
# https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md
export LLAMA_CPP_REPO=https://github.com/ggml-org/llama.cpp
mkdir --parents $HOME/Projects
pushd $HOME/Projects > /dev/null
  echo "....Cloning llama.cpp $LLAMA_CPP_VERSION"
  rm --force --recursive llama.cpp
  git clone --quiet --branch $LLAMA_CPP_VERSION $LLAMA_CPP_REPO 2>/dev/null
  cd llama.cpp

  echo "....Configuring llama.cpp"
  if [[ "$COMPUTE_MODE" == "CUDA" ]]
  then
    export CUDACXX="/usr/local/cuda-13.3/bin/nvcc"
    cmake -B build \
      -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS -DGGML_OPENCL_EMBED_KERNELS=ON -DGGML_VULKAN=1 -DGGML_CUDA=ON \
      >> $LOGFILE 2>&1

  else
    cmake -B build \
      -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS -DGGML_OPENCL_EMBED_KERNELS=ON -DGGML_VULKAN=1 \
      >> $LOGFILE 2>&1

  fi

  echo "....Compiling llama.cpp"
  /usr/bin/time cmake --build build --config Release -j$(nproc) \
    >> $LOGFILE 2>&1
  echo "....Installing llama.cpp"
  sudo cmake --install build \
    >> $LOGFILE 2>&1
  sudo /usr/sbin/ldconfig \
    >> $LOGFILE 2>&1
  echo "....llama.cpp installed"

popd > /dev/null
