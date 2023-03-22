apiVersion: v1
kind: Secret
metadata:
  name: kubernetes-service-catalog
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  url: {{ argocd.ksc.url }}
  password: {{ argocd.ksc.pat }}
  username: {{ argocd.ksc.organization }}
  insecure: "false" # Ignore validity of server's TLS certificate. Defaults to "false"
  forceHttpBasicAuth: "true" # Skip auth method negotiation and force usage of HTTP basic auth. Defaults to "false"
  enableLfs: "true" # Enable git-lfs for this repository. Defaults to "false"