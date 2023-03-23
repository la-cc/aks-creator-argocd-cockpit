apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  annotations:
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: {{ cluster.argocd.ingress.issuer }}
    cert-manager.io/common-name: "{{ cluster.argocd.ingress.host }}"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  ingressClassName: nginx
  rules:
    - host: {{ cluster.argocd.ingress.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  name: https
  tls:
    - hosts:
        - {{ cluster.argocd.ingress.host }}
      secretName: argocd-secret # do not change, this is provided by Argo CD
