module "resource_group" {
  source = "github.com/la-cc/terraform-azure-resource-group?ref=1.0.0"

  name     = format("rg-%s-%s", var.name, terraform.workspace)
  location = var.location
  tags     = var.tags

}


module "network" {
  source = "github.com/la-cc/terraform-azure-network?ref=1.0.0"

  resource_group_name           = module.resource_group.name
  name                          = format("vnet-%s-%s", var.name, terraform.workspace)
  virtual_network_address_space = ["10.0.0.0/8"]
  tags                          = var.tags

  depends_on = [
    module.resource_group
  ]

}

module "kubernetes" {
  source = "github.com/la-cc/terraform-azure-kubernetes?ref=1.1.3"

  aks_name               = format("aks-%s-%s", var.name, terraform.workspace)
  resource_group_name    = module.resource_group.name
  location               = module.resource_group.location
  virtual_network_id     = module.network.virtual_network_id
  virtual_network_name   = module.network.virtual_network_name
  orchestrator_version   = var.orchestrator_version
  kubernetes_version     = var.kubernetes_version
  vm_size                = var.vm_size
  max_pods_per_node      = var.max_pods_per_node
  node_pool_count        = var.node_pool_count
  network_policy         = var.network_policy
  network_plugin         = var.network_plugin
  enable_node_pools      = var.enable_node_pools
  node_pools             = var.node_pools
  local_account_disabled = var.local_account_disabled
  enable_aad_rbac        = var.enable_aad_rbac
  admin_list             = var.admin_list
  load_balancer_sku      = var.load_balancer_sku
  tags                   = var.tags

  depends_on = [
    module.resource_group
  ]


}

