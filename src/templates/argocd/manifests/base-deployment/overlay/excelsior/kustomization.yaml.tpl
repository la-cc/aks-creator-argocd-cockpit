apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base/cert-manager
  - ../../base/external-dns
  - ../../base/ingress-nginx

patchesStrategicMerge:
{% if argocd.externalDNS.enable %}
  - patches/external-dns-values.yaml
{% endif %}
  - patches/cert-manager-values.yaml
  - patches/ingress-nginx-values.yaml
