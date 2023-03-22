apiVersion: builtin
kind: HelmChartInflationGenerator
metadata:
  name: external-dns
valuesInline:
  provider: azure
  azure:
    resourceGroup: "{{ argocd.externalDNS.resource_group }}"
    tenantId: "{{ argocd.externalDNS.tenantID }}"
    subscriptionId: "{{ argocd.externalDNS.subscriptionID }}"
    useManagedIdentityExtension: true
  domainFilters:
  {%- for filter in argocd.externalDNS.domain_filters %}
    - {{ filter }}
  {%- endfor %}
  txtOwnerId: {{ argocd.externalDNS.txtOwnerId }}

