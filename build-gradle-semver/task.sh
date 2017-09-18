#!/bin/sh

set -eu
set -o pipefail

cd project

./gradlew build

cd ..

cp project/build/libs/*.jar task-output/.
