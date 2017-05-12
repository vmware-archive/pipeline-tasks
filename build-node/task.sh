#!/bin/ash
#
# All UPERCASE variables are provided externally from this script

set -eu
set -o pipefail

cd project

npm install
npm test
gulp clean build

cd ..
