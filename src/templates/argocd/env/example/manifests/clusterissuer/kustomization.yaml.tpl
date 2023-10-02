apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
{% if cluster.argocd.security is defined %}
  - clusterissuer-dns.yaml
  - clusterissuer-http.yaml
{% endif %}
