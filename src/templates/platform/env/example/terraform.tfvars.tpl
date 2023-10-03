{% if cluster.azure_public_dns is defined %}
azure_cloud_zone     = "{{ cluster.azure_public_dns.azure_cloud_zone }}"
{% endif %}
kubernetes_version   = "{{ cluster.kubernetes_version }}"
orchestrator_version = "{{ cluster.orchestrator_version }}"
name                 = "{{ cluster.name }}-{{ cluster.stage }}"
node_pool_count      = "{{ cluster.node_pool_count }}"
vm_size              = "{{ cluster.vm_size }}"
local_account_disabled = true
load_balancer_sku      = "standard"
admin_list             = {{ cluster.admin_list | tojson }}
authorized_ip_ranges   = {{ cluster.authorized_ip_ranges | tojson }}

azuread_display_name   = "{{ cluster.azuread_user.display_name }}"
azuread_user_name      = "{{ cluster.azuread_user.name }}"
mail_nickname          = "{{ cluster.azuread_user.mail_nickname }}"
key_vault_name         = "{{ cluster.azure_key_vault.name }}"


{% if cluster.node_pools.enable_node_pools  is defined %}
enable_node_pools    = "{{ cluster.node_pools is defined | lower }}"

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

{% if cluster.argocd_aad_app is defined %}
argocd_aad_app = {
{%- for app in cluster.argocd_aad_app %}
  "{{ app.name }}" = {
    app_owners                   = {{ app.app_owners | tojson }}
    app_role_assignment_required = false
    display_name                 = "{{ app.display_name }}"
    logout_url                   = "{{ app.logout_url }}"
    redirect_uris                = {{ app.redirect_uris | tojson }}
    {%- if app.roles %}
    roles                        = {
      {%- for role in app.roles %}
      "{{ role.name }}" = {
        app_role_id         = "{{ role.id }}"
        principal_object_id = "{{ role.object_id }}"
      }{% if not loop.last %},{% endif %}
      {%- endfor %}
    }
    {%- endif %}
  }{% if not loop.last %},{% endif %}
{%- endfor %}
}
{% endif %}

tags = {
  Maintainer  = "{{ azure_tags.maintainer }}"
  Owner       = "{{ azure_tags.owner }}"
  PoC         = "AKS"
  TF-Managed  = "true"
  Environment = "{{ cluster.stage }}"
}
