# pipeline-tasks
Common Concourse Pipeline Tasks

## Examples

All examples use the following resources:

```
resource_types:
- name: cf-cli-resource
  type: docker-image
  source:
    repository: patrickcrocker/cf-cli-resource
    tag: 2.0.0

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

```
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
