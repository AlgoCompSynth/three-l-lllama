#! /usr/bin/env bash

set -eu

echo "* PiOS Install *"

pushd ./installers > /dev/null

    for script in \
        1-root-scripts.sh \
        2-user-scripts.sh \
        3-update-search-databases.sh

    do
        ./$script

    done

popd > /dev/null

echo "* Finished PiOS Install *"
echo ""
