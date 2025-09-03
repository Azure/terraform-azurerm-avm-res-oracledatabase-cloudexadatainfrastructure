locals {
  databaseServerType = lower(var.shape) == "exadata.x11m" && var.databaseServerType == null ? "X11M" : var.databaseServerType
  storageServerType  = lower(var.shape) == "exadata.x11m" && var.storageServerType == null ? "X11M-HC" : var.storageServerType
}

resource "azapi_resource" "odaa_infra" {
  type = "Oracle.Database/cloudExadataInfrastructures@2025-03-01"

  name      = var.name
  parent_id = var.resource_group_id
  location  = var.location
  tags      = var.tags
  body = {
    "location" : var.location,
    "zones" : [
      var.zone
    ],
    "shape" : var.shape,
    "storageCount" : var.storage_count,
    "databaseServerType" : local.databaseServerType,
    "storageServerType" : local.storageServerType,

    "customerContacts" : var.customerContacts,

    "properties" : {
      "computeCount" : var.compute_count,
      "displayName" : var.display_name,
      "maintenanceWindow" : {
        "leadTimeInWeeks" : var.maintenance_window_leadtime_in_weeks,
        "preference" : var.maintenance_window_preference,
        "patchingMode" : var.maintenance_window_patching_mode,
        "customActionTimeoutInMins" : var.customActionTimeoutInMins,
        "isCustomActionTimeoutEnabled" : var.isCustomActionTimeoutEnabled,
        "daysOfWeek" : var.maintenance_window_daysOfWeek,
        "hoursOfDay" : var.maintenance_window_hoursOfDay,
        "months" : var.maintenance_window_months,
        "weeksOfMonth" : var.maintenance_window_weeksOfMonth
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

