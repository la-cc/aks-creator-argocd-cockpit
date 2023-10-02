apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base/cert-manager
  - ../../base/external-dns
  - ../../base/ingress-nginx
  - ../../base/external-secrets

patches:
{% if cluster.argocd.externalDNS is defined %}
- path: patches/external-dns-values.yaml
{% endif %}
- path: patches/cert-manager-values.yaml
- path: patches/ingress-nginx-values.yaml
- path: patches/external-secrets-values.yaml