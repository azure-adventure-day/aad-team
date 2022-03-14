resource "azurerm_security_center_subscription_pricing" "seccenteracr" {
  tier          = "Standard"
  resource_type = "Containers"
}
