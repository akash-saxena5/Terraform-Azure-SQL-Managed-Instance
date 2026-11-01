
# ==========================================
# Create Resource Group
# ==========================================

resource "azurerm_resource_group" "sqlmi_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# ==========================================
# Create Virtual Network - vnet
# ==========================================

resource "azurerm_virtual_network" "sqlmi_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.sqlmi_rg.location
  resource_group_name = azurerm_resource_group.sqlmi_rg.name

  address_space = var.vnet_address_space

  tags = var.tags
}

# ==========================================
# Create Subnet
# ==========================================

resource "azurerm_subnet" "sqlmi_subnet" {
  name                 = var.mi_subnet_name
  resource_group_name  = azurerm_resource_group.sqlmi_rg.name
  virtual_network_name = azurerm_virtual_network.sqlmi_vnet.name

  address_prefixes = var.mi_subnet_address_prefixes

  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name = "Microsoft.Sql/managedInstances"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# ==========================================
# Create Network Security Group - NSG
# ==========================================

resource "azurerm_network_security_group" "sqlmi_nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.sqlmi_rg.location
  resource_group_name = azurerm_resource_group.sqlmi_rg.name

  tags = var.tags
}

# ==========================================
# Associate NSG with MI Subnet
# ==========================================

resource "azurerm_subnet_network_security_group_association" "sqlmi_nsg_assoc" {
  subnet_id                 = azurerm_subnet.sqlmi_subnet.id
  network_security_group_id = azurerm_network_security_group.sqlmi_nsg.id
}

# ==========================================
# Create Route Table
# ==========================================

resource "azurerm_route_table" "sqlmi_rt" {
  name                = var.route_table_name
  location            = azurerm_resource_group.sqlmi_rg.location
  resource_group_name = azurerm_resource_group.sqlmi_rg.name

  bgp_route_propagation_enabled = true

  tags = var.tags
}

# ==========================================
# Associate Route Table with MI Subnet
# ==========================================

resource "azurerm_subnet_route_table_association" "sqlmi_rt_assoc" {
  subnet_id      = azurerm_subnet.sqlmi_subnet.id
  route_table_id = azurerm_route_table.sqlmi_rt.id
}

# ==========================================
# Azure SQL Managed Instance
# ==========================================

resource "azurerm_mssql_managed_instance" "sqlmi" {
  name                = var.managed_instance_name
  resource_group_name = azurerm_resource_group.sqlmi_rg.name
  location            = azurerm_resource_group.sqlmi_rg.location

  sku_name           = var.sku_name
  vcores             = var.vcores
  storage_size_in_gb = var.storage_size_in_gb
  license_type       = var.license_type

  subnet_id = azurerm_subnet.sqlmi_subnet.id

  public_data_endpoint_enabled = var.public_data_endpoint_enabled

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  collation           = var.collation
  timezone_id         = var.timezone_id
  minimum_tls_version = var.minimum_tls_version

  # System-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  # Ensure networking associations exist
  depends_on = [
    azurerm_subnet_network_security_group_association.sqlmi_nsg_assoc,
    azurerm_subnet_route_table_association.sqlmi_rt_assoc
  ]
}
