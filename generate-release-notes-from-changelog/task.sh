#!/bin/bash

set -eu
set -o pipefail

[ 'true' = "${DEBUG:-}" ] && set -x

: "${CHANGELOG_FILE:?not set or empty}"
: "${VERSION_FILE:?not set or empty}"
: "${RELEASE_NOTES_FILE:?not set or empty}"

function error_and_exit() {
  local message=${1:-<no message set>}
  echo "ERROR: $message" >&2
  exit 1
}

[ ! -f "version/$VERSION_FILE" ] && error_and_exit "version file does not exist: version/$VERSION_FILE"
version=$(cat "version/$VERSION_FILE")

[ ! -f "task-input/$CHANGELOG_FILE" ] && error_and_exit "changelog file does not exist: task-input/$CHANGELOG_FILE"
capture=false
content=
while read line; do

  # Matches variations of start line: ## [2.0.0] - some other text
  if ! $capture && echo $line | grep -oEq "^##\s\[{0,}$version]{0,}\s{0,}.*$"; then
    capture=true
  fi

  # Matches variations of stop line: ## [1.0.0] - some other text
  if $capture && [ -n "$content" ] && echo $line | grep -oEq "^##\s\[{0,}.*]{0,}\s{0,}.*$"; then
    capture=false
  fi

  # Matches markdown links at bottom of file: [1.0.0]: https://...
  if $capture && [ -n "$content" ] && echo $line | grep -oEq "^\[.*$"; then
    capture=false
  fi

  [ $capture = true ] && content+="$line"$'\n'

done <"task-input/$CHANGELOG_FILE"

echo "$content" > task-output/${RELEASE_NOTES_FILE}

echo "Release Notes:"
echo "-------------"
cat task-output/${RELEASE_NOTES_FILE}
