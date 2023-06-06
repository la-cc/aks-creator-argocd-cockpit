apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: {{ cluster.argocd.externalSecrets.name }}
  namespace: argocd
spec:
  refreshInterval: 1h
  secretStoreRef:
    kind: ClusterSecretStore
    name: azure-cluster-secret-store
  target:
    name: {{ cluster.argocd.externalSecrets.name }}
    # optional: specify a template with any additional markup you would like added to the downstream Secret resource.
    # This template will be deep merged without mutating any existing fields. For example: you cannot override metadata.name.
    template:
      metadata:
        labels:
          argocd.argoproj.io/secret-type: repository
  data:
    - secretKey: url
      remoteRef:
        key: url
    - secretKey: sshPrivateKey
      remoteRef:
        key: sshPrivateKey
        decodingStrategy: Base64
