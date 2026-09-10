#! /bin/bash -l

set -eu

source set-installer-envars
export LOGFILE=$HOME/Logfiles/homebrew.log
rm --force $LOGFILE

echo "....Installing Homebrew"
NONINTERACTIVE=1 /bin/bash -c \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  >> $LOGFILE 2>&1

if [[ "$(grep linuxbrew $HOME/.bashrc 2> /dev/null | wc -l)" == "0" ]]
then
  echo "....Adding Homebrew init to the command line"
  echo "" >> $HOME/.bashrc
  echo \
    'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' \
    >> $HOME/.bashrc

fi

echo "....Finished"
echo ""
