apiVersion: v1
kind: Secret
metadata:
  name: kubernetes-service-catalog
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  url: {{ cluster.argocd.ksc.url }}
{% if cluster.argocd.ksc.git_repository_private %}
  password: {{ cluster.argocd.ksc.pat }}
  username: {{ cluster.argocd.ksc.organization }}
{% endif %}
  insecure: "false" # Ignore validity of server's TLS certificate. Defaults to "false"
  forceHttpBasicAuth: "true" # Skip auth method negotiation and force usage of HTTP basic auth. Defaults to "false"
  enableLfs: "true" # Enable git-lfs for this repository. Defaults to "false"