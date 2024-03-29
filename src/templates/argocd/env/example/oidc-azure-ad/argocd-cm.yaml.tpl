{% if cluster.argocd.oidc_config is defined %}
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
  name: argocd-cm
  namespace: argocd
data:
  configManagementPlugins: |
    - name: kustomize-build-with-helm
      generate:
        command: [ "sh", "-c" ]
        args: [ "kustomize build --enable-helm" ]
  url: {{ cluster.argocd.oidc_config.url }} # Replace with the external base URL of your Argo CD
  application.instanceLabelKey: {{ cluster.argocd.oidc_config.instanceLabelKey }}
  oidc.config: |
    name: Azure
    issuer: https://login.microsoftonline.com/{{ cluster.argocd.oidc_config.tenantID }}/v2.0
    clientID: {{ cluster.argocd.oidc_config.clientID }}
    clientSecret: $oidc.azure.clientSecret
    requestedIDTokenClaims:
      groups:
          essential: true
    requestedScopes:
      - openid
      - profile
      - email
{% endif %}