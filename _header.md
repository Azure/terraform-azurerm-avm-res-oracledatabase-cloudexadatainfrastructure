# avm-res-oracledatabase-cloudexadatainfrastructure
This repository contains a Terraform module for deploying Oracle Database Cloud Exadata Infrastructure using Azure Verified Modules (AVM). The module provisions scalable Oracle Cloud Exadata Infrastructure in an enterprise-ready configuration on Microsoft Azure.
## Known issues
- Idempotency Issue with Exadata Infrastructure documented [here](https://github.com/oci-landing-zones/terraform-oci-multicloud-azure/issues/33)
- Update/Changes. Oracle Exadata Infrastructure resource at this moment does not support updates, so every attempt to change any of its properties will trigger the destroy and recreation of the resource. Documented [here](https://github.com/oci-landing-zones/terraform-oci-multicloud-azure/issues/39) and [here](https://github.com/oci-landing-zones/terraform-oci-multicloud-azure/issues/40) 
## Features
- Deploys Oracle Database Cloud Exadata Infrastructure on Azure
- Supports telemetry and monitoring
- Configurable maintenance windows
- Configurable resource operation timeouts
## Prerequisites
- Terraform >= 1.9.2
- Azure CLI
- An Azure subscription
## Requirements
The following requirements are needed by this module:
- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9.2)
- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 1.14.0)
- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.116.0)
- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)
- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)
## Usage
```hcl 
terraform {
  required_version = ">= 1.9.2"
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
  }
  zone = "3"
}
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}
resource "azurerm_resource_group" "this" {
  location = local.location
  name     = "example-resource-group"
  tags     = local.tags
}
module "default" {
  source                               = "../../"
  location                             = local.location
  name                                 = "odaa-infra-${random_string.suffix.result}"
  display_name                         = "odaa-infra-${random_string.suffix.result}"
  resource_group_id                    = azurerm_resource_group.this.id
  zone                                 = local.zone
  compute_count                        = 2
  storage_count                        = 3
  shape                                = "Exadata.X9M"
  maintenance_window_leadtime_in_weeks = 0
  maintenance_window_preference        = "NoPreference"
  maintenance_window_patching_mode     = "Rolling"
  tags                                 = local.tags
  enable_telemetry                     = local.enable_telemetry

  # Optional: Configure custom timeouts for resource operations
  # timeouts = {
  #   create = "2h"   # Default: 6h
  #   delete = "1h"   # Default: 3h
  # }
}
```

## Inputs
| Name                                 | Type        | Default Value      | Description                                                                 |
|--------------------------------------|-------------|--------------------|-----------------------------------------------------------------------------|
| `compute_count`                      | `number`    |                    | The number of compute nodes in the infrastructure.                          |
| `display_name`                       | `string`    |                    | The display name of the infrastructure.                                     |
| `location`                           | `string`    |                    | Azure region where the resource should be deployed.                         |
| `name`                               | `string`    |                    | The name of the Oracle Exadata Infrastructure resource.                     |
| `resource_group_id`                  | `string`    |                    | The resource group ID where the resources will be deployed.                 |
| `storage_count`                      | `number`    |                    | The number of storage servers in the infrastructure.                        |
| `zone`                               | `string`    |                    | The Availability Zone for the resource.                                     |
| `enable_telemetry`                   | `bool`      | `true`             | Controls whether telemetry is enabled.                                      |
| `maintenance_window_leadtime_in_weeks` | `number`    | `0`                | The maintenance window lead time in weeks.                                  |
| `maintenance_window_patching_mode`   | `string`    | `"Rolling"`        | The maintenance window patching mode.                                       |
| `maintenance_window_preference`      | `string`    | `"NoPreference"`   | The maintenance window preference.                                          |
| `shape`                              | `string`    | `"Exadata.X9M"`    | The shape of the infrastructure.                                            |
| `tags`                               | `map(string)` | `null`             | (Optional) Tags of the resource.                                            |
| `timeouts`                           | `object`    | `{}`               | Configuration for resource operation timeouts. Supports `create` (default: 6h) and `delete` (default: 3h). |
## Outputs
| Name         | Type   | Description                        |
|--------------|--------|------------------------------------|
| `resource`   | `any`  | This is the full output for the resource. |
| `resource_id`| `string` | This is the ID of the resource.   |
## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
## Contributing
Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for details on our code of conduct, and the process for submitting pull requests.
