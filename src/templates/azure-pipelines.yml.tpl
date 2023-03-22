trigger:
  batch: true
  branches:
    include:
      - main

variables:
  - group: argocd-cockpit

jobs:
  - job: deploy_kubernetes_cluster
    workspace:
      clean: all
    steps:
      - checkout: self
      {%- for cluster in clusters %}
      - template: azure-pipelines/fetch-kubeconfig.yaml
        parameters:
          clusters:
            - name: {{ cluster.name }}-{{ cluster.stage }}
              repositoryName: {{ cluster.name }}
      - template: azure-pipelines/apply-services.yaml
        parameters:
          clusters:
            - name: {{ cluster.name }}-{{ cluster.stage }}
              repositoryName: {{ cluster.name }}
      - template: azure-pipelines/apply-fleet-cluster.yaml
        parameters:
          clusters:
            - name: {{ cluster.name }}-{{ cluster.stage }}
              repositoryName: {{ cluster.name }}
      {%- endfor %}
