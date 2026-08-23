#! /usr/bin/env bash

set -eu

source set-installer-envars

echo "....Setting up home directory"
mkdir --parents $HOME/.local/bin $HOME/Logfiles $HOME/Projects
export LOGFILE=$HOME/Logfiles/command-line.log
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
  font-fira-code-nerd-font \
  fzf \
  gh \
  lua \
  luajit \
  luarocks \
  neovim \
  node \
  ripgrep \
  starship \
  uv \
  >> $LOGFILE 2>&1

echo "....Cleaning up"
brew cleanup --prune all --scrub --quiet \
  >> $LOGFILE 2>&1

echo "....Setting starship and neovim configuration files"
mkdir --parents $HOME/.config
cp -rp starship.toml nvim $HOME/.config

if [[ "$(grep starship $HOME/.bashrc | wc -l)" == 0 ]]
then
  echo "....Appending starship init to $HOME/.bashrc"
  cat aliases.sh >> $HOME/.bashrc
  echo 'eval "$(starship init bash)"' >> $HOME/.bashrc

fi

# https://unsloth.ai/docs/get-started/install/linux#install-unsloth-core-with-uv
echo "....Creating $UNSLOTH_VENV"
uv venv --clear $UNSLOTH_VENV --python 3.13 \
  >> $LOGFILE 2>&1

echo "....Adding \$UNSLOTH_VENV activation to the command line"
echo "source $UNSLOTH_VENV/bin/activate" \
  >> $HOME/.bashrc

echo "....Activating $UNSLOTH_VENV"
source $UNSLOTH_VENV/bin/activate

echo "....Installing unsloth and vllm via pip"
uv pip install unsloth vllm --torch-backend=auto \
  >> $LOGFILE 2>&1
unsloth --install-completion \
  >> $LOGFILE 2>&1

echo "....Installing OpenCode"
npm i -g opencode-ai \
  >> $LOGFILE 2>&1

echo "....Installing Pi coding agent"
npm install -g --ignore-scripts @earendil-works/pi-coding-agent \
  >> $LOGFILE 2>&1

echo "....Installing pi-llama plugin"
pi install git:github.com/huggingface/pi-llama \
  >> $LOGFILE 2>&1

echo "....Installing goose"
curl -fsSL \
  https://github.com/aaif-goose/goose/releases/download/stable/download_cli.sh \
  | CONFIGURE=false bash \
  >> $LOGFILE 2>&1

echo "....Finished"
echo ""
