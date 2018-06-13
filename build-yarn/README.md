# build-yarn

This task is opinionated on how your `package.json` should be structured.

Only three scripts are called:
```
yarn install
yarn test
yarn bundle -p --output-path=../js-assets/
```

These scripts are treated as the interface into all webapp projects passed through the pipeline. This allows developers to include implementation details specific to each project, while the pipeline can remain general enough to serve multiple projects.

Therefore, it's recommended you structure `test` with things such as linting, and `bundle` with whatever you feel is necessary to build your project.

For example, notice how `test` calls other scripts which are included in the `package.json`:
```json
"scripts": {
  "test": "jest --config ./jest/jest.config.json && yarn run lint && yarn run stylelint",
  "updateSnapshots": "jest -u --config ./jest/jest.config.json",
  "lint": "eslint src/main/resources/assets/**/*.js",
  "stylelint": "stylelint src/main/resources/assets/**/*.less",
  "bundle": "rimraf ./target/classes/static && webpack --bail",
  "bundle-dev": "yarn run bundle --devtool source-map",
  "watch": "nodemon --exec yarn run bundle-dev --watch src/main/resources/assets -L"
},
```