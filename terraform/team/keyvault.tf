resource "azurerm_key_vault" "aksvauls" {
  name                        = "${var.deployment_name}-vault"
  location                    = azurerm_resource_group.aksrg.location
  resource_group_name         = azurerm_resource_group.aksrg.name
  enabled_for_disk_encryption = false
  tenant_id                   = var.tenant_id

  sku_name = "standard"

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = {
    environment = var.deployment_name
  }
}

# https://www.terraform.io/docs/providers/azurerm/r/key_vault_secret.html
# resource "azurerm_key_vault_secret" "appinsights_secret" {
#   name         = "appinsights-key"
#   value        = azurerm_application_insights.aksainsights.instrumentation_key
#   key_vault_id = azurerm_key_vault.aksvault.id
  
#   tags = {
#     environment = var.deployment_name
#   }
# }
