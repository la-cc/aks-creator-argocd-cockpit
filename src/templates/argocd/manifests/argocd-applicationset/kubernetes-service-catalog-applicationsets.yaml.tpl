apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kubernetes-service-catalog-applicationsets-initializer
  # You'll usually want to add your resources to the argocd namespace.
  namespace: argocd
  # Add this finalizer ONLY if you want these to cascade delete.
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  # Add labels to your application object.
  labels:
    name: initializer
spec:
  # The project the application belongs to.
  project: default

  # Source of the application manifests
  source:
    repoURL: {{ argocd.ksc.url }}
    targetRevision: main
    path: ./argocd-applicationsets

    # directory
    directory:
      recurse: true

  # Destination cluster and namespace to deploy the application
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd

  # Sync policy
  syncPolicy:
    automated:
      prune: false
      selfHeal: true
      allowEmpty: false
    syncOptions:
      - Validate=false
      - CreateNamespace=true
      - PrunePropagationPolicy=foreground
      - PruneLast=true
    retry:
      limit: 5 # number of failed sync attempt retries; unlimited number of attempts if less than 0
      backoff:
        duration: 5s # the amount to back off. Default unit is seconds, but could also be a duration (e.g. "2m", "1h")
        factor: 2 # a factor to multiply the base duration after each failed retry
        maxDuration: 3m # the maximum amount of time allowed for the backoff strategy

  revisionHistoryLimit: 10