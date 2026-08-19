echo "....Setting versions"
export CMAKE_VERSION=4.4.2
export LLAMA_CPP_VERSION=v0.1.2
export LLVM_VERSION=22
export LLVM_PATH=/usr/lib/llvm-$LLVM_VERSION/bin
export TERRA_VERSION=1.2.2

echo "....Prepending $LLVM_PATH to PATH"
export PATH=$LLVM_PATH:$PATH
echo "PATH: $PATH"
