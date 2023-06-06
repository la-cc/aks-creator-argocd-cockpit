apiVersion: builtin
kind: HelmChartInflationGenerator
metadata:
  name: external-secrets
valuesInline:
  serviceMonitor:
    # -- Specifies whether to create a ServiceMonitor resource for collecting Prometheus metrics
    enabled: false
