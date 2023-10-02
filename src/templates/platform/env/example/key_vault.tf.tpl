{% if cluster.azure_key_vault is defined %}
resource "azurerm_key_vault_secret" "url" {
  name         = "url"
  value        = "{{ cluster.azure_key_vault.git_repo_url }}"
  key_vault_id = module.key_vault.id
}

resource "azurerm_key_vault_secret" "private_key" {
  name         = "sshPrivateKey"
  value        = base64encode(tls_private_key.main.private_key_pem)
  key_vault_id = module.key_vault.id
}

resource "azurerm_key_vault_secret" "public_key" {
  name         = "sshPublicKey"
  value        = tls_private_key.main.public_key_openssh
  key_vault_id = module.key_vault.id
}


resource "azurerm_key_vault_secret" "svc_user_pw" {
  name         = "{{ cluster.azure_key_vault.svc_user_pw_name }}"
  value        = azuread_user.svc_user.password
  key_vault_id = module.key_vault.id
}

resource "azurerm_key_vault_secret" "bastion_vm_tls_private_key" {
  name         = "sshPrivateKeyBastionVM"
  content_type = format("%s %s%s", "ssh", "sysadmin@", module.bastion_vm.ip_address)
  value        = base64encode(module.bastion_vm.tls_private_key)
  key_vault_id = module.key_vault.id

  depends_on = [
    module.key_vault
  ]
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
{% endif %}