apiVersion: builtin
kind: HelmChartInflationGenerator
metadata:
  name: external-dns
valuesInline:
  provider: azure
  azure:
    resourceGroup: "{{ cluster.argocd.externalDNS.resource_group }}"
    tenantId: "{{ cluster.argocd.externalDNS.tenantID }}"
    subscriptionId: "{{ cluster.argocd.externalDNS.subscriptionID }}"
    useManagedIdentityExtension: true
  domainFilters:
  {%- for filter in cluster.argocd.externalDNS.domain_filters %}
    - {{ filter }}
  {%- endfor %}
  txtOwnerId: {{ cluster.argocd.externalDNS.txtOwnerId }}

