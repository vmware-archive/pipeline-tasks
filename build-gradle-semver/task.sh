#!/bin/sh

set -eu
set -o pipefail

cd project

./gradlew build

cd ..

cp -R project/build task-output/.
