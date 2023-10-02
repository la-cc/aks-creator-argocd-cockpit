{% if cluster.azuread_user is defined %}
resource "random_password" "password" {
  length = 24
}

resource "azuread_user" "svc_user" {
  user_principal_name = var.azuread_user_name
  display_name        = var.azuread_display_name
  mail_nickname       = var.mail_nickname
  password            = random_password.password.result
}
{% endif %}