#! /usr/bin/env bash

set -eu

source set-installer-envars

export LOGFILE=$HOME/Logfiles/ai-tools.log
rm --force $LOGFILE

echo "....Activating Homebrew PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

echo "....Installing brew packages"
brew trust anomalyco/tap
brew install --yes --quiet \
  bubblewrap \
  node \
  anomalyco/tap/opencode \
  pi-coding-agent \
  uv \
  >> $LOGFILE 2>&1
brew install --yes --quiet --cask \
  claude-code \
  codex \
  >> $LOGFILE 2>&1

echo "....Cleaning up"
brew cleanup --prune all --scrub --quiet \
  >> $LOGFILE 2>&1

echo "....Installing Unsloth Studio"
# https://unsloth.ai/download/linux
curl -fsSL https://unsloth.ai/install.sh | UNSLOTH_SKIP_AUTOSTART=1 sh \
  >> $LOGFILE 2>&1

echo "....Installing unsloth bash completions"
$HOME/.local/bin/unsloth --install-completion

if [[ "$(which distrobox-export 2> /dev/null | wc -l)" -gt "0" ]]
then
  echo "....Exporting Unsloth Studio to host app list"
  distrobox-export --app \
    $HOME/.local/share/applications/unsloth-studio.desktop

fi

echo "....Finished"
echo ""
