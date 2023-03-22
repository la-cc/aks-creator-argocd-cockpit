apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-http
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: {{ argocd.security.clusterIssuerHTTP.e_mail }}
    privateKeySecretRef:
      name: letsencrypt-http
    solvers:
      - http01:
          ingress:
            class: nginx
            podTemplate:
              spec:
                nodeSelector:
                  "kubernetes.io/os": linux