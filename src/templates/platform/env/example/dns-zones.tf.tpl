{% if cluster.azure_public_dns is defined %}
module "dns_zone" {
  source = "github.com/la-cc/terraform-azure-dns-zone?ref=1.0.0"

  name                = var.azure_cloud_zone
  resource_group_name = module.resource_group_platform.name
  tags                = var.tags

  depends_on = [
    module.resource_group_platform
  ]

}
{% endif %}