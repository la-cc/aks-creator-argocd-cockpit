apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  annotations:
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: {{ argocd.ingress.issuer }}
    cert-manager.io/common-name: "{{ argocd.ingress.host }}"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  ingressClassName: nginx
  rules:
    - host: {{ argocd.ingress.host }}
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
        - {{ argocd.ingress.host }}
      secretName: argocd-secret # do not change, this is provided by Argo CD
