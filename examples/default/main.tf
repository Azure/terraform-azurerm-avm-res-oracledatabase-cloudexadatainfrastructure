terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

locals {
  enable_telemetry = true
  location         = "eastus"
  tags = {

    scenario  = "Default"
    project   = "Oracle Database @ Azure"
    createdby = "ODAA Infra - AVM Module"
    delete    = "yes"
  }
  zone = "3"
}



# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = local.location
  name     = module.naming.resource_group.name_unique
  tags     = local.tags
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "default" {
  source = "../../"

  compute_count                        = 2
  display_name                         = "odaa-infra-${random_string.suffix.result}"
  location                             = local.location
  name                                 = "odaa-infra-${random_string.suffix.result}"
  resource_group_id                    = azurerm_resource_group.this.id
  storage_count                        = 3
  zone                                 = local.zone
  enable_telemetry                     = local.enable_telemetry
  maintenance_window_leadtime_in_weeks = 0
  maintenance_window_patching_mode     = "Rolling"
  maintenance_window_preference        = "NoPreference"
  shape                                = "Exadata.X9M"
  tags                                 = local.tags
}

