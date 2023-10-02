apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: argocd
resources:
{% if cluster.argocd.ksc is defined %}
  - argocd-applicationset/kubernetes-service-catalog-applicationsets.yaml
{% endif %}
