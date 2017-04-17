#!/bin/ash
# This script assumes Maven Wrapper is used with Maven v3.5.0 or higher.
#   see: https://maven.apache.org/maven-ci-friendly.html
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

./mvnw install $args

output=$(printf 'LOCAL_REPOSITORY=${settings.localRepository}\nGROUP_ID=${project.groupId}\nARTIFACT_ID=${project.artifactId}\nPOM_VERSION=${project.version}\n0\n' | ./mvnw help:evaluate $args)

localRepository=$(echo "$output" | grep '^LOCAL_REPOSITORY' | cut -d = -f 2)
groupId=$(echo "$output" | grep '^GROUP_ID' | cut -d = -f 2)
artifactId=$(echo "$output" | grep '^ARTIFACT_ID' | cut -d = -f 2)
pomVersion=$(echo "$output" | grep '^POM_VERSION' | cut -d = -f 2)

cd ..

cp -R $localRepository/${groupId//.//}/$artifactId/$pomVersion/* task-output/.
