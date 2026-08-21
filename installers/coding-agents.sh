#! /usr/bin/env -S bash -l

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/coding-agents.log
rm --force $LOGFILE

echo "....Activating Homebrew PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

echo "....Installing brew packages"
brew trust frostyard/tap
brew install --yes --quiet \
  block-goose-cli \
  opencode \
  pi-coding-agent \
  >> $LOGFILE 2>&1

echo "....Cleaning up"
brew cleanup --prune all --scrub --quiet \
  >> $LOGFILE 2>&1

echo "....Installing pi-llama plugin"
pi install git:github.com/huggingface/pi-llama \
  >> $LOGFILE 2>&1

echo "....Finished"
