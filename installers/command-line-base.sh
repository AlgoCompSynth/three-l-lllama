#! /usr/bin/env bash

set -eu

source set-installer-envars

echo "....Setting up home directory"
mkdir --parents $HOME/.local/bin $HOME/Logfiles $HOME/Projects
export LOGFILE=$HOME/Logfiles/command-line-base.log
rm --force $LOGFILE

NONINTERACTIVE=1 /bin/bash -c \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  >> $LOGFILE 2>&1

echo "....Adding Homebrew to the command line"
echo "" >> $HOME/.bashrc
echo \
  'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' \
  >> $HOME/.bashrc

echo "....Activating Homebrew PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

echo "....Installing brew packages"
brew install --yes --quiet \
  fennel \
  fzf \
  gh \
  lua \
  luajit \
  luarocks \
  neovim \
  node \
  ripgrep \
  uv \
  >> $LOGFILE 2>&1

echo "....Cleaning up"
brew cleanup --prune all --scrub --quiet \
  >> $LOGFILE 2>&1

echo "....Setting neovim configuration files"
mkdir --parents $HOME/.config
cp -rp nvim $HOME/.config

echo "....Appending aliases to $HOME/.bashrc"
cat << ALIASES_END >> $HOME/.bashrc

# begin three-l-lllama aliases
# make sure $HOME/.local/bin is in $PATH
if [[ ! "$PATH" =~ "$HOME/.local/bin" ]]
then
  export PATH="$HOME/.local/bin:$PATH"
fi

alias l='ls -CF --color=auto'
alias ll='ls -Fltr'
alias la='ls -FAltr'
alias vi=nvim
alias vim=nvim

export EDITOR=nvim
export VISUAL=nvim
# end three-l-lllama aliases

ALIASES_END

echo "....Finished"
echo ""
