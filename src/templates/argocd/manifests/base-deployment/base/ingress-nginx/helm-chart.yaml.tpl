apiVersion: builtin
kind: HelmChartInflationGenerator
metadata:
  name: ingress-nginx
releaseName: ingress-nginx
name: ingress-nginx
version: 4.5.*
repo: https://kubernetes.github.io/ingress-nginx
#valuesFile: values.yaml
valuesInline: {}
IncludeCRDs: true
namespace: ingress-nginx
