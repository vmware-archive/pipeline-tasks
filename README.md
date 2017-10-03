# pipeline-tasks
Common Concourse Pipeline Tasks

## Examples

All examples use the following resources:

```yaml
resource_types:
- name: cf-cli-resource
  type: docker-image
  source:
    repository: pivotalpa/cf-cli-resource
    tag: latest

resources:
- name: pipeline-tasks
  type: git
  source:
    uri: https://github.com/Pivotal-Field-Engineering/pipeline-tasks.git
    branch: master

- name: cf-test
  type: cf-cli-resource
  source:
    api: https://api.run.pivotal.io
    skip_cert_check: false
    username: user@example.com
    password: oh-so-secret
    org: user-org
    space: test-space
```

## Generate a Cloud Foundry Manifest

```yaml
- name: test
  plan:
  - aggregate:
    - get: pipeline-tasks
    - get: artifact
  - task: generate-manifest
    file: pipeline-tasks/generate-manifest/task.yml
    params:
      MF_NAME: myapp
      MF_HOST: myapp
      MF_SERVICES: [ myapp-db, myapp-mq ]
      MF_ENV:
        RAILS_ENV: production
        RACK_ENV: production
        JBP_CONFIG_OPEN_JDK_JRE: '{ jre: { version: 1.8.0_+ }, memory_calculator: { stack_threads: 200 } }'
  - put: cf-push
    resource: cf-test
    params:
      command: zero-downtime-push
      manifest: task-output/manifest.yml
      path: artifact/myapp-*.jar
      current_app_name: {{cf-test-app-name}}
```

## Generate release information

This example showcases tasks commonly used with [github-release](https://github.com/concourse/github-release-resource):
* `generate-github-release`: Generates a version string (ex: v1.0.0) for the `release-name` and `release-tag` files.
* `generate-commitish`: Generates the [commitish](https://stackoverflow.com/questions/23303549/what-are-commit-ish-and-tree-ish-in-git) file.
* `generate-release-notes`: Generates the release notes for a particular version by parsing a change log format based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

```yaml
- name: shipit
  serial_groups: [version]
  plan:
  - aggregate:
    - get: pipeline-tasks
    - get: project
      passed: [build]
    - get: version
      passed: [build]
      params: {bump: final}
  - task: generate-github-release
    file: pipeline-tasks/generate-github-release/task.yml
    output_mapping: {task-output: generate-github-release-output}
  - task: generate-commitish
    file: pipeline-tasks/generate-commitish/task.yml
    output_mapping: {task-output: generate-commitish-output}
  - task: generate-release-notes
    file: pipeline-tasks/generate-release-notes-from-changelog/task.yml
    input-mapping: {task-input: project}
    output-mapping: {task-output: generate-release-notes-output}
  - put: github-release
    params:
      name: generate-github-release-output/release-name
      tag: generate-github-release-output/release-tag
      commitish: generate-commitish-output/commitish
      body: generate-release-notes-output/RELEASE_NOTES.md
  - put: version
    params: {file: version/version}

```
