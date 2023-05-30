{% if azure_backend.enable %}
terraform {
  backend "azurerm" {
    resource_group_name  = "{{ azure_backend.resource_group_name_backend }}"
    storage_account_name = "{{ azure_backend.storage_account_name }}"
    container_name       = "tfstate"
    key                  = "terraform.tfstate" # refers to the file name
  }
}
{% endif %}

terraform {
  required_version = ">= 1.4.0"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.58.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.39.0"
    }
  }
}

