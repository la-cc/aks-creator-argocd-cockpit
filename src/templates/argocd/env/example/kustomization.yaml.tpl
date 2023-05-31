apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: argocd
resources:
  - https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/ha/install.yaml
{% if cluster.argocd.ingress.enable %}
  - ingress.yaml
{% endif %}
