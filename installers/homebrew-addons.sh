#! /usr/bin/env -S bash -l

set -eu

echo "....Activating Homebrew PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

echo "....Installing brew packages"
brew install --yes --quiet \
  pi-coding-agent \
  >> $LOGFILE 2>&1

echo "....Cleaning up"
brew cleanup --prune all --scrub --quiet \
  >> $LOGFILE 2>&1

echo "....Installing pi-llama plugin"
pi install git:github.com/huggingface/pi-llama \
  >> $LOGFILE 2>&1

echo "....Finished"
