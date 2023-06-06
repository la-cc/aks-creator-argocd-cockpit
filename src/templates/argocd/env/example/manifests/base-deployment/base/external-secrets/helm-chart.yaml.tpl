apiVersion: builtin
kind: HelmChartInflationGenerator
metadata:
  name: external-secrets
releaseName: external-secrets
name: external-secrets
version: 0.8.*
repo: https://charts.external-secrets.io
#valuesFile: values.yaml
valuesInline: {}
IncludeCRDs: true
namespace: external-secrets
