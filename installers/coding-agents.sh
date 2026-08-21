#! /usr/bin/env -S bash -l

set -eu

source set-versions.sh

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/coding-agents.log
rm --force $LOGFILE

# https://nodejs.org/en/download
export ARCH="$(uname --machine)"
if [[ "$ARCH" == "aarch64" ]]
then
  export TARBALL="https://nodejs.org/dist/v$NODEJS_VERSION/node-v$NODEJS_VERSION-linux-arm64.tar.xz"

elif [[ "$ARCH" == "x86_64" ]]
then
  export TARBALL="https://nodejs.org/dist/v$NODEJS_VERSION/node-v$NODEJS_VERSION-linux-x64.tar.xz"

else
  echo "Unsupported hardware - exit -255!"
  exit -255

fi

echo "..Installing Node.js"
curl -fsSL \
  $TARBALL \
  | tar xJf - --strip-components=1 --directory=$HOME/.local \
  > /dev/null
echo "npm --version $(npm --version)"
echo "..Node.js is installed locally"

echo "....Installing Pi coding agent via official installer"
npm install -g --ignore-scripts @earendil-works/pi-coding-agent

echo "....Installing pi-llama plugin"
pi install git:github.com/huggingface/pi-llama \
  >> $LOGFILE 2>&1

echo "....Finished"
echo ""
