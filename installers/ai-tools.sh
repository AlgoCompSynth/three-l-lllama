#! /bin/bash -l

set -eu

source set-installer-envars
export LOGFILE=$HOME/Logfiles/ai-tools.log
rm --force $LOGFILE

echo "....Activating Homebrew PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

echo "....Installing Unsloth Core"
# https://github.com/unslothai/unsloth/tree/main#unsloth-core-code-based
# We already have `uv` via Homebrew!
uv venv $UNSLOTH_ENV --python 3.13
source $UNSLOTH_ENV/bin/activate
uv pip install unsloth --torch-backend=auto \
  >> $LOGFILE 2>&1

echo "....Installing Unsloth Studio"
unsloth studio setup \
  >> $LOGFILE 2>&1

echo "....Installing unsloth bash completions"
unsloth --install-completion

echo "....Appending Unsloth Studio activation to $HOME/.bashrc"
echo "source $UNSLOTH_ENV/bin/activate" >> $HOME/.bashrc

echo "....Installing coding agents"
brew trust anomalyco/tap
brew install --yes --quiet \
  anomalyco/tap/opencode \
  fd \
  pi-coding-agent \
  >> $LOGFILE 2>&1
brew install --yes --quiet --cask \
  claude-code \
  codex \
  >> $LOGFILE 2>&1

echo "....Cleaning up"
brew cleanup --prune all --scrub --quiet \
  >> $LOGFILE 2>&1

echo "....Finished"
echo ""
