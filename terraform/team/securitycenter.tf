resource "azurerm_security_center_subscription_pricing" "defendercont" {
  tier          = "Standard"
  resource_type = "Containers"
}
