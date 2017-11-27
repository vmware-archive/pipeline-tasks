#!/bin/ash
#
# All UPERCASE variables are provided externally from this script

set -eu
set -o pipefail

version=$(cat version/version)

cd project

args="-Drevision=$version"
[ -n "$MAVEN_PROJECTS" ] && args="$args --projects $MAVEN_PROJECTS"
[ -n "$MAVEN_REPO_MIRROR" ] && args="$args -Drepository.url=$MAVEN_REPO_MIRROR";
[ -n "$MAVEN_REPO_USERNAME" ] && args="$args -Drepository.username=$MAVEN_REPO_USERNAME";
[ -n "$MAVEN_REPO_PASSWORD" ] && args="$args -Drepository.password=$MAVEN_REPO_PASSWORD";
[ "true" = "$MAVEN_REPO_CACHE_ENABLE" ] && args="$args -Dmaven.repo.local=$PWD/.m2repository"

./mvnw test-compile failsafe:integration-test failsafe:verify $args

cd ..
