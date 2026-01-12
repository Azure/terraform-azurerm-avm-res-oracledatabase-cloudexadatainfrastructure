#====================================================================================================
# Cloud Exadata VM Cliuster variables
#====================================================================================================
variable "compute_count" {
  type        = number
  description = "The number of compute nodes in the infrastructure."
}

variable "display_name" {
  type        = string
  description = "The display name of the infrastructure."
}

variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the the Oracle Exatada Infrastructure resource."
}

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the resources will be deployed."
  nullable    = false
}

variable "storage_count" {
  type        = number
  description = "The number of storage servers in the infrastructure."
}

variable "zone" {
  type        = string
  description = "The Availability Zone for the resource."
  nullable    = false

  validation {
    condition     = can(regex("^[1-3]$", var.zone))
    error_message = "The zone must be a number between 1 and 3."
  }
}

variable "custom_action_timeout_in_mins" {
  type        = number
  default     = 0
  description = "Determines the amount of time the system will wait before the start of each database server patching operation. Custom action timeout is in minutes and valid value is between 15 to 120 (inclusive)."
}

variable "customer_contacts" {
  type = list(
    object({ email = string })
  )
  default     = null
  description = "The list of customer email addresses that receive information from Oracle about the specified OCI Database service resource. Oracle uses these email addresses to send notifications about planned and unplanned software maintenance updates, information about system hardware, and other information needed by administrators. Up to 10 email addresses can be added to the customer contacts for a cloud Exadata infrastructure instance."
}

# Align with 2025-03-01 https://learn.microsoft.com/en-us/rest/api/oracle/cloud-exadata-infrastructures/create-or-update?view=rest-oracle-2025-03-01&tabs=HTTP
variable "database_server_type" {
  type        = string
  default     = null
  description = "The database server model type of the cloud Exadata infrastructure resource. Null for X9M. Default to X11M for X11M"
}

# tflint-ignore: terraform_unused_declarations
variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "is_custom_action_timeout_enabled" {
  type        = bool
  default     = false
  description = "If true, enables the configuration of a custom action timeout (waiting period) between database server patching operations."
}

variable "maintenance_window_days_of_week" {
  type = list(
    object({ name = string })
  )
  default     = null
  description = "Days during the week when maintenance should be performed."
}

variable "maintenance_window_hours_of_day" {
  type        = list(number)
  default     = null
  description = "The window of hours during the day when maintenance should be performed. The window is a 4 hour slot. Valid values are - 0 - represents time slot 0:00 - 3:59 UTC - 4 - represents time slot 4:00 - 7:59 UTC - 8 - represents time slot 8:00 - 11:59 UTC - 12 - represents time slot 12:00 - 15:59 UTC - 16 - represents time slot 16:00 - 19:59 UTC - 20 - represents time slot 20:00 - 23:59 UTC"
}

variable "maintenance_window_leadtime_in_weeks" {
  type        = number
  default     = 0
  description = "The maintenance window load time in weeks."
}

variable "maintenance_window_months" {
  type = list(
    object({ name = string })
  )
  default     = null
  description = "Months during the year when maintenance should be performed."
}

variable "maintenance_window_patching_mode" {
  type        = string
  default     = "Rolling"
  description = "The maintenance window patching mode."
}

variable "maintenance_window_preference" {
  type        = string
  default     = "NoPreference"
  description = "The maintenance window preference. Valid values: CustomPreference, NoPreference"

  validation {
    condition     = contains(["CustomPreference", "NoPreference"], var.maintenance_window_preference)
    error_message = "Valid values: CustomPreference, NoPreference"
  }
}

variable "maintenance_window_weeks_of_month" {
  type        = list(number)
  default     = null
  description = "Weeks during the month when maintenance should be performed. Weeks start on the 1st, 8th, 15th, and 22nd days of the month, and have a duration of 7 days. Weeks start and end based on calendar dates, not days of the week. For example, to allow maintenance during the 2nd week of the month (from the 8th day to the 14th day of the month), use the value 2. Maintenance cannot be scheduled for the fifth week of months that contain more than 28 days. Note that this parameter works in conjunction with the daysOfWeek and hoursOfDay parameters to allow you to specify specific days of the week and hours that maintenance will be performed."
}

#====================================================================================================
# AVM Interface variables
#====================================================================================================
# tflint-ignore: terraform_unused_declarations
variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.
- `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created. This field is only used in cross-tenant scenario.
- `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.
  

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

variable "shape" {
  type        = string
  default     = "Exadata.X9M"
  description = "The shape of the infrastructure. Valid value Exadata.X9M and Exadata.X11M"

  validation {
    condition     = contains(["Exadata.X9M", "Exadata.X11M"], var.shape)
    error_message = "Valid value Exadata.X9M and Exadata.X11M"
  }
}

variable "storage_server_type" {
  type        = string
  default     = null
  description = "The storage server model type of the cloud Exadata infrastructure resource. Null for X9M. Default to X11M-HC for X11M"
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "timeouts" {
  type = object({
    create = optional(string, "6h")
    delete = optional(string, "3h")
  })
  default     = {}
  description = <<DESCRIPTION
Configuration for resource operation timeouts.

- `create` - (Optional) The timeout for the create operation. Defaults to `6h` (6 hours) due to the extended time required to provision Oracle Exadata infrastructure.
- `delete` - (Optional) The timeout for the delete operation. Defaults to `3h` (3 hours).

Note: Update operations are not supported by Oracle Exadata Infrastructure resources. Any property change will trigger a destroy and recreate of the resource.

Example:
```hcl
timeouts = {
  create = "2h"
  delete = "30m"
}
```
DESCRIPTION
}
