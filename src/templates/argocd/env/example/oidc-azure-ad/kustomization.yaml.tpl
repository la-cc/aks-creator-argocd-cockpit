apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: argocd
resources:
{% if cluster.argocd.oidc_config is defined %}
  - argocd-cm.yaml
  - argocd-rbac-cm.yaml
{% endif %}