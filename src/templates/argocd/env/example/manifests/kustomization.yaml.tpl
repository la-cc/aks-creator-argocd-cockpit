apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: argocd
resources:
{% if cluster.argocd.ksc.enable %}
  - argocd-repository/kubernetes-service-catalog.yaml
  - argocd-applicationset/kubernetes-service-catalog-applicationsets.yaml
{% endif %}
