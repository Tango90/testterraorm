terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "cosmosdb-rg"
  location = "eastus"
}

resource "azurerm_cosmos_account" "db" {
  name     = "cosmosdb"
  location = azurerm_resource_group.rg.location
  resoruce_group_name = azurerm_resource_group.rg.name
  offer_type = "Standard"
  kind = "GlobalDocumentDB"
}

consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
}

geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 1
}
}








