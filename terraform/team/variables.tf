# azure subscription id

# Terraform backend
terraform {
  backend "azurerm" {
    resource_group_name  = "VAR_KUBE_RG"
    storage_account_name = "VAR_TERRAFORM_NAME"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

variable "subscription_id" {
    default = "VAR_SUBSCRIPTION_ID"
}

# azure ad tenant id
variable "tenant_id" {
    default = "VAR_TENANT_ID"
}

# default tags applied to all resources
variable "deployment_name" {
    default = "VAR_TEAM_NAME"
}

variable "vm_size" {
    default = "Standard_DS3_v2"
}

# kubernetes version
variable "kubernetes_version_prefix" {
  type        = string
  default     = "1.23"
  description = "The Kubernetes Version prefix (MAJOR.MINOR) to be used by the AKS cluster. The BUGFIX version is determined automatically (latest)."
}

variable "location" {
    default = "WestEurope"
}
