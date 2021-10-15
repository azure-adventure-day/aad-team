resource "azurerm_security_center_subscription_pricing" "seccenteraks" {
  tier          = "Standard"
  resource_type = "KubernetesService"
}

resource "azurerm_security_center_subscription_pricing" "seccenteracr" {
  tier          = "Standard"
  resource_type = "ContainerRegistry"
}
