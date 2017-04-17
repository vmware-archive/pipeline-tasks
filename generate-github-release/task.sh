#!/bin/bash

version=$(cat version/version)

echo v${version} > task-output/release-name
echo v${version} > task-output/release-tag
