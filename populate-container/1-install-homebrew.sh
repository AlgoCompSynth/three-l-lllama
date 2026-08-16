#! /usr/bin/env -S bash -l

set -eu

mkdir --parents $HOME/Logfiles
export LOGFILE=$HOME/Logfiles/install-homebrew.log
rm --force $LOGFILE

NONINTERACTIVE=1 /bin/bash -c \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  >> $LOGFILE 2>&1

echo "....Adding Homebrew to the command line"
echo "" >> $HOME/.bashrc
echo \
  'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' \
  >> $HOME/.bashrc

echo "....Homebrew setup is complete"
