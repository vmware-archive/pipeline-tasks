#!/bin/ash
#
# All UPERCASE variables are provided externally from this script

set -eu
set -o pipefail

cd project

args=""
[ -n "$MAVEN_PROJECTS" ] && args="$args --projects $MAVEN_PROJECTS"
[ -n "$MAVEN_REPO_MIRROR" ] && args="$args -Drepository.url=$MAVEN_REPO_MIRROR";
[ -n "$MAVEN_REPO_USERNAME" ] && args="$args -Drepository.username=$MAVEN_REPO_USERNAME";
[ -n "$MAVEN_REPO_PASSWORD" ] && args="$args -Drepository.password=$MAVEN_REPO_PASSWORD";

output=$(printf 'LOCAL_REPOSITORY=${settings.localRepository}\nGROUP_ID=${project.groupId}\nARTIFACT_ID=${project.artifactId}\nPOM_VERSION=${project.version}\n0\n' | ./mvnw help:evaluate $args)

localRepository=$(echo "$output" | grep '^LOCAL_REPOSITORY' | cut -d = -f 2)
groupId=$(echo "$output" | grep '^GROUP_ID' | cut -d = -f 2)
artifactId=$(echo "$output" | grep '^ARTIFACT_ID' | cut -d = -f 2)
pomVersion=$(echo "$output" | grep '^POM_VERSION' | cut -d = -f 2)

./mvnw install $args

cd ..

cp -R $localRepository/${groupId//.//}/$artifactId/$pomVersion/* task-output/.
