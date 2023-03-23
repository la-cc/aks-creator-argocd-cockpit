apiVersion: builtin
kind: HelmChartInflationGenerator
metadata:
  name: external-dns
releaseName: external-dns
name: external-dns
version: 6.14.*
repo: https://charts.bitnami.com/bitnami
#valuesFile: values.yaml
valuesInline: {}
IncludeCRDs: true
namespace: external-dns
