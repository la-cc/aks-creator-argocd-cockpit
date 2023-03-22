apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: argocd
resources:
{% if argocd.ksc.enable %}
  - argocd-project/argocd-project-bootstrap.yaml
  - argocd-repository/kubernetes-service-catalog.yaml
  - argocd-applicationset/kubernetes-service-catalog-applicationsets.yaml
{% endif %}
