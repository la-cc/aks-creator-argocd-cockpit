apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: bootstrap
  namespace: argocd
  # Finalizer that ensures that project is not deleted until it is not referenced by any application
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  # Project description
  description: Bootstrap Project to install new clusters

  # Allow manifests to deploy from any Git repos
  sourceRepos:
    - "*"

  destinations:
    - namespace: "*"
      server: "*"
      name: "*"

      # Deny all cluster-scoped resources from being created, except for Namespace
  clusterResourceWhitelist:
    - group: "*"
      kind: "*"

  # Deny all namespaced-scoped resources from being created, except for Deployment and StatefulSet
  namespaceResourceWhitelist:
    - group: "*"
      kind: "*"

  # Enables namespace orphaned resource monitoring.
  orphanedResources:
    warn: true