{% if cluster.azure_public_dns.enable %}
module "dns_zone" {
  source = "github.com/la-cc/terraform-azure-dns-zone?ref=1.0.0"

  name                = var.azure_cloud_zone
  resource_group_name = module.resource_group.name
  tags                = var.tags

  depends_on = [
    module.resource_group
  ]

}
{% endif %}