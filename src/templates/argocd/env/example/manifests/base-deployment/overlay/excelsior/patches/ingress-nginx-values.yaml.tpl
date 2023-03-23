apiVersion: builtin
kind: HelmChartInflationGenerator
metadata:
  name: ingress-nginx
valuesInline:
  podSecurityPolicy:
    enabled: true
    ingressClassResource:
      default: true
  defaultBackend:
    enabled: true
