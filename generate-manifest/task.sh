#!/bin/bash
#
# All UPERCASE variables are provided externally from this yml

set -eu
set -o pipefail

cd task-output

# Build the yaml create script
yml=
[ "${MF_NAME:-}" ] && yml+="applications[0].name: $MF_NAME\n"
[ "${MF_BUILDPACK:-}" ] && yml+="applications[0].buildpack: $MF_BUILDPACK\n"
[ "${MF_COMMAND:-}" ] && yml+="applications[0].command: $MF_COMMAND\n"
[ "${MF_DISK_QUOTA:-}" ] && yml+="applications[0].disk_quota: $MF_DISK_QUOTA\n"
[ "${MF_DOMAIN:-}" ] && yml+="applications[0].domain: $MF_DOMAIN\n"
[ "${MF_DOMAINS:-}" ] && yml+="applications[0].domains: $MF_DOMAINS\n"
[ "${MF_HEALTH_CHECK_HTTP_ENDPOINT:-}" ] && yml+="applications[0].health-check-http-endpoint: $MF_HEALTH_CHECK_HTTP_ENDPOINT\n"
[ "${MF_HEALTH_CHECK_TYPE:-}" ] && yml+="applications[0].health-check-type: $MF_HEALTH_CHECK_TYPE\n"
[ "${MF_HOST:-}" ] && yml+="applications[0].host: $MF_HOST\n"
[ "${MF_HOSTS:-}" ] && yml+="applications[0].hosts: $MF_HOSTS\n"
[ "${MF_INSTANCES:-}" ] && yml+="applications[0].instances: $MF_INSTANCES\n"
[ "${MF_MEMORY:-}" ] && yml+="applications[0].memory: $MF_MEMORY\n"
[ "${MF_NO_HOSTNAME:-}" ] && yml+="applications[0].no-hostname: $MF_NO_HOSTNAME\n"
[ "${MF_NO_ROUTE:-}" ] && yml+="applications[0].no-route: $MF_NO_ROUTE\n"
[ "${MF_PATH:-}" ] && yml+="applications[0].path: $MF_PATH\n"
[ "${MF_RANDOM_ROUTE:-}" ] && yml+="applications[0].random_route: $MF_RANDOM_ROUTE\n"
[ "${MF_ROUTES:-}" ] && yml+="applications[0].routes: $MF_ROUTES\n"
[ "${MF_STACK:-}" ] && yml+="applications[0].stack: $MF_STACK\n"
[ "${MF_TIMEOUT:-}" ] && yml+="applications[0].timeout: $MF_TIMEOUT\n"
[ "${MF_ENV:-}" ] && yml+="applications[0].env: $MF_ENV\n"
[ "${MF_SERVICES:-}" ] && yml+="applications[0].services: $MF_SERVICES\n"

if [ -n "$yml" ]; then
  echo -e "---\n$(echo -e $yml | yaml n -s -)" > manifest.yml
  echo 'Generated manifest:'
  cat manifest.yml
else
  echo 'No manifest options specified: nothing to generate!'
fi

cd ..
