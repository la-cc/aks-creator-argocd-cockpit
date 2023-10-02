apiVersion: builtin
kind: HelmChartInflationGenerator
metadata:
  name: cert-manager
releaseName: cert-manager
name: cert-manager
version: 1.13.*
repo: https://charts.jetstack.io
#valuesFile: values.yaml
valuesInline: {}
IncludeCRDs: true
namespace: cert-manager
