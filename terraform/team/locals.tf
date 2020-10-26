locals {
    hash_suffix = substr(sha256(azurerm_resource_group.aksrg.id), 0, 6)
}