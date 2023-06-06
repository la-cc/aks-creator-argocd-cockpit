apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - manifests/cert-manager/namespace.yaml
  - manifests/external-dns/namespace.yaml
  - manifests/ingress-nginx/namespace.yaml
  - manifests/external-secrets/namespace.yaml
  - manifests/external-secrets/cluster-secret-store.yaml
  - manifests/external-secrets/external-secret.yaml

generators:
  - ../../overlay/excelsior/
