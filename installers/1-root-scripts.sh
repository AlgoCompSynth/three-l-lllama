#! /bin/bash -l

set -eu

echo "** Root Scripts **"

mkdir --parents $HOME/Logfiles
for script in \
  base-packages.sh \
  trixie-cuda.sh \
  llvm-apt.sh \
  terralang.sh \
  update-search-databases.sh

do
  ./$script

done

echo "** Finished Root Scripts **"
echo ""
