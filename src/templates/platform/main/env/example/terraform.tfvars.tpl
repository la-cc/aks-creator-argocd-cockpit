{% if cluster.azure_public_dns.enable %}
azure_cloud_zone     = "{{ cluster.azure_public_dns.azure_cloud_zone }}"
{% endif %}
kubernetes_version   = "{{ cluster.kubernetes_version }}"
orchestrator_version = "{{ cluster.orchestrator_version }}"
name                 = "{{ cluster.name }}"
node_pool_count      = "{{ cluster.node_pool_count }}"
vm_size              = "{{ cluster.vm_size }}"
local_account_disabled = true
admin_list             = {{ cluster.admin_list | tojson }}

{% if cluster.node_pools.enable_node_pools %}
enable_node_pools    = "{{ cluster.node_pools.enable_node_pools |lower }}"

node_pools = {
{%- for pool in cluster.node_pools.pool %}
  "{{ pool.name }}" = {
    enable_auto_scaling    = false
    enable_host_encryption = false
    enable_node_public_ip  = false
    max_count              = {{ pool.max_count }}
    max_pods               = 45
    min_count              = {{ pool.min_count }}
    name                   = "{{ pool.name }}"
    node_count             = {{ pool.node_count }}
    node_labels = {}
    node_taints     = []
    os_disk_size_gb = "32"
    vm_size         = "Standard_B4ms"
    zones           = ["1"]
  }
{%- endfor %}
}

{% endif %}

tags = {
  Maintainer  = "Team-X"
  Owner       = "Team-X"
  PoC         = "AKS"
  TF-Managed  = "true"
  Environment = "{{ cluster.name }}-{{ cluster.stage }}"
}
