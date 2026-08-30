#! /usr/bin/env bash

set -eu

source set-installer-envars

echo "....Setting up home directory"
mkdir --parents $HOME/.local/bin $HOME/Logfiles $HOME/Projects
export LOGFILE=$HOME/Logfiles/command-line-base.log
rm --force $LOGFILE

if [[ ! -d /home/linuxbrew ]]
then
  echo "....Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    >> $LOGFILE 2>&1

fi

if [[ "$(grep linuxbrew $HOME/.bashrc 2> /dev/null | wc -l)" == "0" ]]
then
  echo "....Adding Homebrew init to the command line"
  echo "" >> $HOME/.bashrc
  echo \
    'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' \
    >> $HOME/.bashrc

fi

echo "....Activating Homebrew PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

echo "....Installing brew packages"
brew install --yes --quiet \
  font-caskaydia-cove-nerd-font \
  font-fira-code-nerd-font \
  neovim \
  ripgrep \
  starship \
  >> $LOGFILE 2>&1

echo "....Cleaning up"
brew cleanup --prune all --scrub --quiet \
  >> $LOGFILE 2>&1

echo "....Setting neovim configuration files"
mkdir --parents $HOME/.config
cp -rp nvim $HOME/.config

echo "....Setting starship configuration file"
cp starship.toml $HOME/.config/

if [[ "$(grep starship $HOME/.bashrc | wc -l)" == 0 ]]
then
  echo "....Appending starship init to $HOME/.bashrc"
  echo "" >> $HOME/.bashrc
  echo 'eval "$(starship init bash)"' >> $HOME/.bashrc

fi

if [[ "$(grep 'end aliases' $HOME/.bashrc | wc -l)" == 0 ]]
then

echo "....Appending aliases to $HOME/.bashrc"
cat << ALIASES_END >> $HOME/.bashrc

# begin aliases
# make sure \$HOME/.local/bin is in \$PATH
if [[ ! "\$PATH" =~ "\$HOME/.local/bin" ]]
then
  export PATH="\$HOME/.local/bin:\$PATH"
fi

alias l='ls -CF --color=auto'
alias ll='ls -Fltr'
alias la='ls -FAltr'
alias vi=nvim
alias vim=nvim

export EDITOR=nvim
export VISUAL=nvim
# end aliases

ALIASES_END

fi

echo "....Finished"
echo ""
