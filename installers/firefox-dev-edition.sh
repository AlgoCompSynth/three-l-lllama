#! /bin/bash -l

set -eu

source set-installer-envars
export LOGFILE=$HOME/Logfiles/firefox-dev-edition.log
rm --force $LOGFILE

# https://support.mozilla.org/en-US/kb/install-firefox-linux#w_install-firefox-deb-package-for-debian-based-and-ubuntu-based-distributions-recommended

echo "....Importing signing key"
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- \
  | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc \
  > /dev/null

echo "....Adding Mozilla repository"
tee /etc/apt/sources.list.d/mozilla.sources > /dev/null << EOF
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF

echo "....Prioritizing Mozilla packages"
sudo tee /etc/apt/preferences.d/mozilla > /dev/null << EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

echo "....Installing Firefox developer edition"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq \
  && apt-get install -qqy \
  firefox-devedition \
  >> $LOGFILE 2>&1

echo "....Finished"
echo ""
