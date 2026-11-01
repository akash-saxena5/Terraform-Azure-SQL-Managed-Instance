
# ==========================================
# Azure Subscription and Environment
# ==========================================

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "environment" {
  description = "Env name like Dev, Test, QA or Prod"
  type        = string
}

variable "location" {
  description = "Location for all resources."
  type        = string
  default     = "eastus"
}

# ==========================================
# Resource Group
# ==========================================

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

# ==========================================
# Virtual Network
# ==========================================

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

# ==========================================
# SQL MI Dedicated Subnet
# ==========================================

variable "mi_subnet_name" {
  description = "Dedicated SQL MI subnet name"
  type        = string
  default     = "snet-sqlmi"
}

variable "mi_subnet_address_prefixes" {
  description = "Address prefixes for the MI subnet"
  type        = list(string)
  default     = ["10.20.1.0/24"]
}

# ==========================================
# Network Security Group and Route Table
# ==========================================

variable "nsg_name" {
  description = "Network Security Group name"
  type        = string
}

variable "route_table_name" {
  description = "Route table name for SQL MI subnet"
  type        = string
}

# ==========================================
# SQL Managed Instance Configuration
# ==========================================

variable "managed_instance_name" {
  description = "Globally unique SQL Managed Instance name"
  type        = string
}

variable "sku_name" {
  description = "SQL MI SKU, such as GP_Gen5 or BC_Gen5"
  type        = string
  default     = "GP_Gen5"
}

variable "vcores" {
  description = "Number of vCores for SQL MI"
  type        = number
  default     = 4
}

variable "storage_size_in_gb" {
  description = "Storage size for SQL MI in GB"
  type        = number
  default     = 32

  validation {
    condition = (
      var.storage_size_in_gb >= 32 &&
      var.storage_size_in_gb % 32 == 0
    )
    error_message = "Storage must be at least 32 GB and a multiple of 32."
  }
}

variable "license_type" {
  description = "LicenseIncluded or BasePrice (Azure Hybrid Benefit)"
  type        = string
  default     = "LicenseIncluded"

  validation {
    condition = contains(
      ["LicenseIncluded", "BasePrice"],
      var.license_type
    )
    error_message = "Use LicenseIncluded or BasePrice."
  }
}

# ==========================================
# SQL Authentication
# ==========================================

variable "administrator_login" {
  description = "SQL MI administrator login name"
  type        = string
  default     = "sqlmiadmin"
}

variable "administrator_login_password" {
  description = "SQL MI administrator password. Supply securely."
  type        = string
  sensitive   = true
}

# ==========================================
# Additional SQL MI Settings
# ==========================================

variable "timezone_id" {
  description = "Windows time zone ID for SQL MI"
  type        = string
  default     = "Eastern Standard Time"
}

variable "minimum_tls_version" {
  description = "Minimum TLS version for SQL MI"
  type        = string
  default     = "1.2"
}

variable "public_data_endpoint_enabled" {
  description = "Enable public SQL MI data endpoint"
  type        = bool
  default     = false
}

variable "collation" {
  description = "SQL MI instance collation"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

# ==========================================
# Resource Tags
# ==========================================

variable "tags" {
  description = "Tags applied to Azure resources"
  type        = map(string)

  default = {
    ManagedBy = "Terraform"
    Project   = "Azure-SQL-MI"
  }
}
