#!/bin/ash
#
# All UPERCASE variables are provided externally from this script

set -eu
set -o pipefail

# copy the artifact to the task-output folder
cp artifact/$CF_APP_PATH task-output/.

cd task-output

# convert 'artifact-*.jar' into 'artifact-1.0.0-rc.1.jar'
appPath=$(ls $CF_APP_PATH)

cat <<EOF >manifest.yml
---
applications:
- name: $CF_APP_NAME
  path: $appPath
EOF

[ -n "$CF_APP_HOST" ]      && echo "  host: $CF_APP_HOST"  >> manifest.yml
[ -n "$CF_APP_MEMORY" ]    && echo "  memory: $CF_APP_MEMORY"  >> manifest.yml
[ -n "$CF_APP_INSTANCES" ] && echo "  instances: $CF_APP_INSTANCES"  >> manifest.yml
[ -n "$CF_APP_TIMEOUT" ]   && echo "  timeout: $CF_APP_TIMEOUT"  >> manifest.yml
# note: should be passed in as an array: [service1,service2,etc]
[ -n "$CF_APP_SERVICES" ]  && echo "  services: $CF_APP_SERVICES"  >> manifest.yml
# note: concourse passes this as a json object, which is cool
[ -n "$CF_APP_ENV_VARS" ]  && echo "  env: $CF_APP_ENV_VARS"  >> manifest.yml

echo "Generated manifest:"
cat manifest.yml

cd ..
