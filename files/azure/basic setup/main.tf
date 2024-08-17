terraform {
  required_version = ">=1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.43.0"
    }
  }

  cloud {

    organization = "Terraform_Prod"

    workspaces {
      name = "remotestate"
    }
  }
}
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

locals {
  tags = {
    "Environment" = var.environment
  }
}

resource "azurerm_resource_group" "rg1" {
  name     = "testrg1"
  location = "Eastus"
}
resource "azurerm_storage_account" "mystorage1" {

  name                          = var.storage_account_name
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg1.name
  account_tier                  = "Standard"
  account_replication_type      = var.environment == "Production" ? "GRS" : "LRS"
  public_network_access_enabled = false
  tags                          = local.tags
}