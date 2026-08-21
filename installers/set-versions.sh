echo "....Setting versions"
export CMAKE_VERSION=4.4.2
export LLAMA_CPP_VERSION=0.2.0
export LLVM_VERSION=22
export LLVM_PATH=/usr/lib/llvm-$LLVM_VERSION/bin
export NODEJS_VERSION=26.7.0 # Current 2026-08-21
export TERRA_VERSION=1.2.2

echo "....Prepending $LLVM_PATH to PATH"
export PATH=$LLVM_PATH:$PATH
echo "PATH: $PATH"
