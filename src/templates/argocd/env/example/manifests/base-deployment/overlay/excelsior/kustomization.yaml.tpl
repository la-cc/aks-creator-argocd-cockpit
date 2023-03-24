apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base/cert-manager
  - ../../base/external-dns
  - ../../base/ingress-nginx

patches:
{% if cluster.argocd.externalDNS.enable %}
- path: patches/external-dns-values.yaml
{% endif %}
- path: patches/cert-manager-values.yaml
- path: patches/ingress-nginx-values.yaml