#! /bin/bash -l

set -eu

echo "** User Scripts **"

mkdir --parents $HOME/.local/bin $HOME/Logfiles $HOME/Projects
for script in \
  homebrew.sh \
  command-line-base.sh \
  ai-tools.sh

do
  ./$script

done

echo "** Finished User Scripts **"
echo ""
