apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: azure-cluster-secret-store
spec:
  provider:
    # provider type: azure keyvault
    azurekv:
      authType: ManagedIdentity
      # URL of your vault instance, see: https://docs.microsoft.com/en-us/azure/key-vault/general/about-keys-secrets-certificates
      vaultUrl: {{ cluster.argocd.externalSecrets.keyVaultURL }}
