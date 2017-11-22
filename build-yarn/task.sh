#!/bin/ash
#
# All UPERCASE variables are provided externally from this script

set -eu
set -o pipefail
[ 'true' = "${DEBUG:-}" ] && set -x

cd project

if [ ! -f "./package.json" ]; then
  echo "package.json not found in root dir: exiting gracefully."
  exit 0;
fi

yarn install
yarn test
yarn bundle -p --output-path=../js-assets/