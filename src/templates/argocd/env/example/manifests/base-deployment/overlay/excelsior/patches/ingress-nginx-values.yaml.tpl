apiVersion: builtin
kind: HelmChartInflationGenerator
metadata:
  name: ingress-nginx
valuesInline:
  controller:
    allowSnippetAnnotations: true
    service:
      annotations:
        service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path: /healthz
  podSecurityPolicy:
    enabled: true
    ingressClassResource:
      default: true
  defaultBackend:
    enabled: true