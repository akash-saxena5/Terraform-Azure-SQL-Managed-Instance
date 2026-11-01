
# ==========================================
# Resource Group Outputs
# ==========================================

output "resource_group_name" {
  description = "Azure Resource Group name"
  value       = azurerm_resource_group.sqlmi_rg.name
}

output "location" {
  description = "Azure region"
  value       = azurerm_resource_group.sqlmi_rg.location
}

# ==========================================
# Networking Outputs
# ==========================================

output "virtual_network_name" {
  description = "Virtual Network name"
  value       = azurerm_virtual_network.sqlmi_vnet.name
}

output "virtual_network_id" {
  description = "Virtual Network resource ID"
  value       = azurerm_virtual_network.sqlmi_vnet.id
}

output "sqlmi_subnet_id" {
  description = "Dedicated SQL MI subnet ID"
  value       = azurerm_subnet.sqlmi_subnet.id
}

output "network_security_group_name" {
  description = "SQL MI Network Security Group"
  value       = azurerm_network_security_group.sqlmi_nsg.name
}

output "route_table_name" {
  description = "SQL MI Route Table name"
  value       = azurerm_route_table.sqlmi_rt.name
}

# ==========================================
# SQL Managed Instance Outputs
# ==========================================

output "sqlmi_name" {
  description = "Azure SQL Managed Instance name"
  value       = azurerm_mssql_managed_instance.sqlmi.name
}

output "sqlmi_id" {
  description = "Azure SQL Managed Instance resource ID"
  value       = azurerm_mssql_managed_instance.sqlmi.id
}

output "sqlmi_fqdn" {
  description = "Fully qualified domain name of SQL MI"
  value       = azurerm_mssql_managed_instance.sqlmi.fqdn
}

output "sqlmi_dns_zone" {
  description = "SQL MI DNS zone"
  value       = azurerm_mssql_managed_instance.sqlmi.dns_zone
}

output "sqlmi_sku" {
  description = "SQL MI service tier and hardware SKU"
  value       = azurerm_mssql_managed_instance.sqlmi.sku_name
}

output "sqlmi_vcores" {
  description = "Number of SQL MI vCores"
  value       = azurerm_mssql_managed_instance.sqlmi.vcores
}

output "sqlmi_storage_gb" {
  description = "SQL MI allocated storage in GB"
  value       = azurerm_mssql_managed_instance.sqlmi.storage_size_in_gb
}

# ==========================================
# Managed Identity Outputs
# ==========================================

output "sqlmi_managed_identity_principal_id" {
  description = "System-assigned managed identity Principal ID"
  value       = azurerm_mssql_managed_instance.sqlmi.identity[0].principal_id
}

output "sqlmi_managed_identity_tenant_id" {
  description = "System-assigned managed identity Tenant ID"
  value       = azurerm_mssql_managed_instance.sqlmi.identity[0].tenant_id
}
