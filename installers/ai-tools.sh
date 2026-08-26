#! /usr/bin/env bash

set -eu

source set-installer-envars

export LOGFILE=$HOME/Logfiles/ai-tools.log
rm --force $LOGFILE

echo "....Activating Homebrew PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

echo "....Installing Unsloth Desktop"
# https://unsloth.ai/download/linux
curl -fsSL https://unsloth.ai/install.sh | UNSLOTH_SKIP_AUTOSTART=1 sh \
  >> $LOGFILE 2>&1
echo "....Installing unsloth bash completions"
$HOME/.local/bin/unsloth --install-completion
echo "....Exporting Unsloth Studio to host app list"
distrobox-export --app \
  $HOME/.local/share/applications/unsloth-studio.desktop

echo "....Installing OpenCode"
brew install anomalyco/tap/opencode \
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
