#! /usr/bin/env bash

set -eu

export LOGFILE=$HOME/Logfiles/starship.log
rm --force $LOGFILE

echo "....Installing brew packages"
brew install --yes --quiet \
  font-fira-code-nerd-font \
  starship \
  >> $LOGFILE 2>&1

echo "....Cleaning up"
brew cleanup --prune all --scrub --quiet \
  >> $LOGFILE 2>&1

echo "....Setting starship configuration file"
mkdir --parents $HOME/.config
cp starship.toml $HOME/.config/

if [[ "$(grep starship $HOME/.bashrc | wc -l)" == 0 ]]
then
  echo "....Appending starship init to $HOME/.bashrc"
  echo 'eval "$(starship init bash)"' >> $HOME/.bashrc

fi

echo "....Finished"
echo ""
