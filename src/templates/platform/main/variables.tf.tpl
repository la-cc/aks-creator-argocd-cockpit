variable "name" {
  type    = string
}

variable "orchestrator_version" {

  type    = string
  default = "1.24.9"

}

variable "kubernetes_version" {
  type    = string
  default = "1.24.9"
}

variable "location" {
  type    = string
  default = "westeurope"

}

variable "enable_aad_rbac" {
  type        = bool
  default     = true
  description = "Is Role Based Access Control based on Azure AD enabled?"

}

variable "admin_list" {
  type        = list(string)
  default     = []
  description = "If rbac is enabled, the default admin will be set over aad groups"

}

variable "local_account_disabled" {
  type        = bool
  default     = false
  description = <<-EOT
  If true local accounts will be disabled. Defaults to false.
  When deploying an AKS Cluster, local accounts are enabled by default.
  Even when enabling RBAC or Azure Active Directory integration, --admin access still exists, essentially as a non-auditable backdoor option.
  With this in mind, AKS offers users the ability to disable local accounts via a flag, disable-local-accounts.
  A field, properties.disableLocalAccounts, has also been added to the managed cluster API to indicate whether the feature has been enabled on the cluster.
  See the documentation for more information:  https://docs.microsoft.com/azure/aks/managed-aad#disable-local-accounts"
  EOT
}

variable "load_balancer_sku" {
  type        = string
  default     = "basic"
  description = "Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Possible values are basic and standard. Defaults to standard"
}

{% if cluster.azure_public_dns.enable %}
variable "azure_cloud_zone" {

  type    = string

}
{% endif %}

variable "vm_size" {

  type    = string
  default = "Standard_B4ms"

}

variable "max_pods_per_node" {
  type    = number
  default = 45
}

variable "node_pool_count" {

  type    = number
}

variable "lock_name" {
  type        = string
  description = "Specifies the name of the Management Lock. Changing this forces a new resource to be created."
  default     = "delete lock on resource-group-level"
}

variable "lock_level" {
  type        = string
  description = "Specifies the Level to be used for this Lock. Possible values are CanNotDelete and ReadOnly. Changing this forces a new resource to be created."
  default     = "CanNotDelete"
}

variable "notes" {
  type        = string
  description = "Specifies some notes about the lock. Maximum of 512 characters. Changing this forces a new resource to be created."
  default     = "Locked, if you want remove the resourcegroup or a resource in this group, you must delete the lock first"
}

variable "network_plugin" {

  type    = string
  default = "azure"

}

variable "network_policy" {

  type    = string
  default = "calico"
}

variable "enable_node_pools" {

  type        = bool
  default     = false
  description = "Allow you to enable node pools"

}


variable "node_pools" {
  type = map(object({
    name                   = string
    vm_size                = string
    zones                  = list(string)
    enable_auto_scaling    = bool
    enable_host_encryption = bool
    enable_node_public_ip  = bool
    max_pods               = number
    node_labels            = map(string)
    node_taints            = list(string)
    os_disk_size_gb        = string
    max_count              = number
    min_count              = number
    node_count             = number
  }))

  description = <<-EOT
    If the default node pool is a Virtual Machine Scale Set, you can define additional node pools by defining this variable.
    As of Terraform 1.0 it is not possible to mark particular attributes as optional. If you don't want to set one of the attributes, set it to null.
  EOT

  default = {}
}


variable "tags" {
  type = map(string)
  default = {
    TF-Managed  = "true"
    Maintainer  = "HPA"
    TF-Worfklow = ""
    Owner       = "HSA"
    PoC         = "AKS"
  }
}