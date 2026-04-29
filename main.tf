# -------------------------------------------------------
# Etap 1: Key Vault
# -------------------------------------------------------
resource "azurerm_key_vault" "default" {
  name                = "kvnameofkvhere"
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags

  sku_name = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  public_network_access_enabled = true
}

# -------------------------------------------------------
# Etap 2: Access Policy dla bieżącego użytkownika
# -------------------------------------------------------
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.default.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create", "Delete", "Get", "List", "Update",
    "Purge", "Recover", "Decrypt", "Encrypt",
    "Sign", "Verify", "WrapKey", "UnwrapKey",
    "GetRotationPolicy", "SetRotationPolicy",
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge", "Recover",
  ]
}

# -------------------------------------------------------
# Etap 3: Klucz RSA
# -------------------------------------------------------
resource "azurerm_key_vault_key" "rsa" {
  name         = "rsa-key"
  key_vault_id = azurerm_key_vault.default.id
  key_type     = "RSA"
  key_size     = 2048
  tags         = local.tags

  key_opts = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

  expiration_date = "2027-01-01T00:00:00Z"

  depends_on = [azurerm_key_vault_access_policy.current_user]
}

# -------------------------------------------------------
# Etap 4: Losowe hasło i sekret
# -------------------------------------------------------
resource "random_password" "app" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}:?"
}

resource "azurerm_key_vault_secret" "app_password" {
  name         = "app-password"
  value        = random_password.app.result
  key_vault_id = azurerm_key_vault.default.id
  tags         = local.tags

  expiration_date = "2027-01-01T00:00:00Z"

  depends_on = [azurerm_key_vault_access_policy.current_user]
}
