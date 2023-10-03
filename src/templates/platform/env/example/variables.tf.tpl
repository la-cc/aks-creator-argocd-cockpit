variable "name" {
  type = string
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


variable "azure_cloud_zone" {

  type = string

}


variable "vm_size" {

  type    = string
  default = "Standard_B4ms"

}

variable "max_pods_per_node" {
  type    = number
  default = 45
}

variable "node_pool_count" {

  type = number
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

variable "authorized_ip_ranges" {

  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = <<-EOT
    Set of authorized IP ranges to allow access to API server, e.g. ["198.51.100.0/24"].
    EOT
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

{% if cluster.azure_key_vault is defined %}
########## Azure Key Vault ##########

variable "network_acls" {

  type = object({
    bypass                     = string,
    default_action             = string,
    ip_rules                   = list(string),
    virtual_network_subnet_ids = list(string),
  })

  default = {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  description = "(Optional) A network_acls block as defined below"

}

variable "key_vault_admin_object_ids" {
  type        = list(string)
  description = "Optional list of object IDs of users or groups who should be Key Vault Administrators. Should only be set, if enable_rbac_authorization is set to true."
  default     = []
}

variable "role_definition_name" {
  type        = string
  description = "The Scoped-ID of the Role Definition. Changing this forces a new resource to be created. Conflicts with role_definition_name"
  default     = "Key Vault Administrator"
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  default     = true
}

variable "key_vault_name" {
  type        = string
  description = "Specifies the name of the Key Vault. Changing this forces a new resource to be created."
}
{% endif %}

{% if cluster.azuread_user is defined %}
########## Azure AD User ##########
variable "azuread_user_name" {

  type        = string
  description = "value of the user name"

}

variable "azuread_display_name" {

  type        = string
  description = "value of the display name"
}

variable "mail_nickname" {

  type        = string
  description = "value of the mail nickname"

}
{% endif %}


{% if cluster.argocd_aad_app is defined %}
########## Azure AD Argo CD Enterprise App + App Registration ##########
variable "argocd_aad_app" {
  type = map(object({
    display_name                 = string
    redirect_uris                = list(string)
    logout_url                   = string
    app_role_assignment_required = bool
    app_owners                   = list(string)
    roles = map(object({
      app_role_id         = string
      principal_object_id = string
    }))

  }))

  default = {}
}

variable "argocd_app_roles" {
  type = map(object({
    allowed_member_types = list(string)
    description          = string
    display_name         = string
    enabled              = bool
    id                   = string
    value                = string


  }))
  default = {

    "argocd_admin" = {
      allowed_member_types = ["User"]
      description          = "ArgodCD Admin Role"
      display_name         = "ArgoCD Admin"
      enabled              = true
      id                   = "1dc5dd87-3e3a-491c-9cd1-bdea64febe6b"
      value                = "Admin"
    }

  }
}
{% endif %}