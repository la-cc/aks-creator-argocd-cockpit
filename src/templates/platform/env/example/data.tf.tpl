data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}


data "azurerm_resource_group" "main" {
  name = module.resource_group_platform.name

  depends_on = [
    module.resource_group_platform
  ]
}

data "azurerm_kubernetes_cluster" "main" {
  name                = format("aks-%s", var.name)
  resource_group_name = module.resource_group_platform.name

  depends_on = [
    module.kubernetes
  ]
}

data "azuread_group" "it_adm" {
  object_id        = "{{ cluster.azure_key_vault.admin_object_ids.ID }}"#{{ cluster.azure_key_vault.admin_object_ids.name }}
  security_enabled = true

}


{% if cluster.azure_key_vault.service_principal_name is defined %}
data "azuread_service_principal" "devops_terraform_cicd" {

  display_name = "{{ cluster.azure_key_vault.service_principal_name }}"
}
{% endif %}