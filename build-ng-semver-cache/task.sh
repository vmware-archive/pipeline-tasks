#!/bin/sh

set -eu
set -o pipefail

version=$(cat version/version)

cd project

npm install

testargs=
[ -n "$NG_TEST_CODE_COVERAGE" ] && testargs="$testargs --code-coverage=$NG_TEST_CODE_COVERAGE"
[ -n "$NG_TEST_CONFIG" ] && testargs="$testargs --config=$NG_TEST_CONFIG"
[ -n "$NG_TEST_SINGLE_RUN" ] && testargs="$testargs --single-run=$NG_TEST_SINGLE_RUN"
[ -n "$NG_TEST_PROGRESS" ] && testargs="$testargs --progress=$NG_TEST_PROGRESS"
[ -n "$NG_TEST_BROWSERS" ] && testargs="$testargs --browsers=$NG_TEST_BROWSERS"
[ -n "$NG_TEST_COLORS" ] && testargs="$testargs --colors=$NG_TEST_COLORS"
[ -n "$NG_TEST_LOG_LEVEL" ] && testargs="$testargs --log-level=$NG_TEST_LOG_LEVEL"
[ -n "$NG_TEST_PORT" ] && testargs="$testargs --port=$NG_TEST_PORT"
[ -n "$NG_TEST_REPORTERS" ] && testargs="$testargs --reporters=$NG_TEST_REPORTERS"
[ -n "$NG_TEST_SOURCEMAPS" ] && testargs="$testargs --sourcemaps=$NG_TEST_SOURCEMAPS"
[ -n "$NG_TEST_POLL" ] && testargs="$testargs --poll=$NG_TEST_POLL"
[ -n "$NG_TEST_ENVIRONMENT" ] && testargs="$testargs --environment=$NG_TEST_ENVIRONMENT"
[ -n "$NG_TEST_APP" ] && testargs="$testargs --app=$NG_TEST_APP"

ng test --watch false $testargs

buildargs=
[ -n "$NG_BUILD_TARGET" ] && buildargs="$buildargs --target=$NG_BUILD_TARGET"
[ -n "$NG_BUILD_ENVIRONMENT" ] && buildargs="$buildargs --environment=$NG_BUILD_ENVIRONMENT"
[ -n "$NG_BUILD_OUTPUT_PATH" ] && buildargs="$buildargs --output-path=$NG_BUILD_OUTPUT_PATH"
[ -n "$NG_BUILD_AOT" ] && buildargs="$buildargs --aot=$NG_BUILD_AOT"
[ -n "$NG_BUILD_SOURCEMAPS" ] && buildargs="$buildargs --sourcemaps=$NG_BUILD_SOURCEMAPS"
[ -n "$NG_BUILD_VENDOR_CHUNK" ] && buildargs="$buildargs --vendor-chunk=$NG_BUILD_VENDOR_CHUNK"
[ -n "$NG_BUILD_COMMON_CHUNK" ] && buildargs="$buildargs --common-chunk=$NG_BUILD_COMMON_CHUNK"
[ -n "$NG_BUILD_BASE_HREF" ] && buildargs="$buildargs --base-href=$NG_BUILD_BASE_HREF"
[ -n "$NG_BUILD_DEPLOY_URL" ] && buildargs="$buildargs --deploy-url=$NG_BUILD_DEPLOY_URL"
[ -n "$NG_BUILD_VERBOSE" ] && buildargs="$buildargs --verbose=$NG_BUILD_VERBOSE"
[ -n "$NG_BUILD_PROGRESS" ] && buildargs="$buildargs --progress=$NG_BUILD_PROGRESS"
[ -n "$NG_BUILD_I18N_FILE" ] && buildargs="$buildargs --i18n-file=$NG_BUILD_I18N_FILE"
[ -n "$NG_BUILD_I18N_FORMAT" ] && buildargs="$buildargs --i18n-format=$NG_BUILD_I18N_FORMAT"
[ -n "$NG_BUILD_LOCALE" ] && buildargs="$buildargs --locale=$NG_BUILD_LOCALE"
[ -n "$NG_BUILD_MISSING_TRANSLATION" ] && buildargs="$buildargs --missing-translation=$NG_BUILD_MISSING_TRANSLATION"
[ -n "$NG_BUILD_EXTRACT_CSS" ] && buildargs="$buildargs --extract-css=$NG_BUILD_EXTRACT_CSS"
[ -n "$NG_BUILD_WATCH" ] && buildargs="$buildargs --watch=$NG_BUILD_WATCH"
[ -n "$NG_BUILD_OUTPUT_HASHING" ] && buildargs="$buildargs --output-hashing=$NG_BUILD_OUTPUT_HASHING"
[ -n "$NG_BUILD_POLL" ] && buildargs="$buildargs --poll=$NG_BUILD_POLL"
[ -n "$NG_BUILD_APP" ] && buildargs="$buildargs --app=$NG_BUILD_APP"
[ -n "$NG_BUILD_DELETE_OUTPUT_PATH" ] && buildargs="$buildargs --delete-output-path=$NG_BUILD_DELETE_OUTPUT_PATH"
[ -n "$NG_BUILD_PRESERVE_SYMLINKS" ] && buildargs="$buildargs --preserve-symlinks=$NG_BUILD_PRESERVE_SYMLINKS"
[ -n "$NG_BUILD_EXTRACT_LICENSES" ] && buildargs="$buildargs --extract-licenses=$NG_BUILD_EXTRACT_LICENSES"
[ -n "$NG_BUILD_SHOW_CIRCULAR_DEPENDENCIES" ] && buildargs="$buildargs --show-circular-dependencies=$NG_BUILD_SHOW_CIRCULAR_DEPENDENCIES"
[ -n "$NG_BUILD_BUILD_OPTIMIZER" ] && buildargs="$buildargs --build-optimizer=$NG_BUILD_BUILD_OPTIMIZER"
[ -n "$NG_BUILD_NAMED_CHUNKS" ] && buildargs="$buildargs --named-chunks=$NG_BUILD_NAMED_CHUNKS"
[ -n "$NG_BUILD_STATS_JSON" ] && buildargs="$buildargs --stats-json=$NG_BUILD_STATS_JSON"

ng build $buildargs

cd ..

cp -R project/${NG_BUILD_OUTPUT_PATH:-dist} task-output/.

if [ -d project/coverage ]; then
  cp -R project/coverage task-output/.
fi
