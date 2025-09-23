locals {
  database_server_type = lower(var.shape) == "exadata.x11m" && var.database_server_type == null ? "X11M" : var.database_server_type
  storage_server_type  = lower(var.shape) == "exadata.x11m" && var.storage_server_type == null ? "X11M-HC" : var.storage_server_type
}

resource "azapi_resource" "odaa_infra" {
  type = "Oracle.Database/cloudExadataInfrastructures@2025-03-01"

  name      = var.name
  parent_id = var.resource_group_id
  location  = var.location
  tags      = var.tags
  body = {
    "zones" : [
      var.zone
    ],
    "properties" : {
      "displayName" : var.display_name,
      "shape" : var.shape,
      "computeCount" : var.compute_count,
      "storageCount" : var.storage_count,
      "databaseServerType" : local.database_server_type,
      "storageServerType" : local.storage_server_type,
      "customerContacts" : var.customer_contacts,
      "maintenanceWindow" : {
        "leadTimeInWeeks" : var.maintenance_window_leadtime_in_weeks,
        "preference" : var.maintenance_window_preference,
        "patchingMode" : var.maintenance_window_patching_mode,
        "customActionTimeoutInMins" : var.custom_action_timeout_in_mins,
        "isCustomActionTimeoutEnabled" : var.is_custom_action_timeout_enabled,
        "daysOfWeek" : var.maintenance_window_days_of_week
        "hoursOfDay" : var.maintenance_window_hours_of_day,
        "months" : var.maintenance_window_months,
        "weeksOfMonth" : var.maintenance_window_weeks_of_month
      }
    }
  }

  ignore_null_property      = true
  schema_validation_enabled = false

  create_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null

  timeouts {
    create = "1h30m"
    delete = "20m"
  }
}

