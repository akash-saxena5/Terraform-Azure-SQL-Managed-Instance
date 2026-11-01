# Azure SQL Managed Instance Deployment using Terraform

Deploy Azure SQL Managed Instance and the required networking infrastructure using Terraform.

This project demonstrates Infrastructure as Code (IaC) practices for provisioning a managed SQL Server platform in Microsoft Azure using the HashiCorp AzureRM provider.

## Overview

The Terraform configuration provisions:

- Azure Resource Group
- Azure Virtual Network
- Dedicated subnet delegated to Azure SQL Managed Instance
- Network Security Group and subnet association
- Route Table and subnet association
- Azure SQL Managed Instance
- System-assigned Managed Identity
- Resource outputs for infrastructure integration

The project provides example configurations for Development, QA, and Production environments.

## Technologies

| Technology | Purpose |
|---|---|
| Terraform 1.7+ | Infrastructure as Code |
| AzureRM Provider 4.x | Azure resource provisioning |
| Random Provider 3.x | Available for future resource naming |
| Azure CLI | Local Azure authentication |
| Microsoft Azure | Cloud infrastructure |
| Azure SQL Managed Instance | Managed SQL Server database platform |
| GitHub | Source control |

## Repository Structure

```text
.
├── .gitignore
├── .terraform.lock.hcl
├── README.md
├── providers.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── dev.tfvars.example
```

## Prerequisites

- Azure subscription
- Terraform CLI 1.7 or later
- Azure CLI
- Azure permissions sufficient to provision SQL Managed Instance and networking resources
- Available SQL MI capacity and vCore quota in the target region
- Available non-overlapping VNet address ranges

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/asaxena1987/terraform-azure-sql-managed-instance.git
cd terraform-azure-sql-managed-instance
```

### 2. Authenticate to Azure

```bash
az login
az account set --subscription "SUBSCRIPTION-ID"
```

### 3. Configure environment variables

Copy the development example file:

```bash
cp dev.tfvars.example dev.tfvars
```

Update the configuration to match your subscription, resource names, region, and networking requirements.

Do not commit your local `.tfvars` files.

### 4. Provide the SQL administrator password

Use a Terraform environment variable instead of storing a password in the configuration.

PowerShell:

```powershell
$SecurePassword = Read-Host "SQL MI Admin Password" -AsSecureString
$env:TF_VAR_administrator_login_password = [System.Net.NetworkCredential]::new("", $SecurePassword).Password
```

### 5. Initialize Terraform

```bash
terraform init
```

### 6. Validate the configuration

```bash
terraform fmt -check -recursive
terraform validate
```

### 7. Preview infrastructure changes

```bash
terraform plan -var-file="dev.tfvars"
```

Review the plan carefully before proceeding.

### 8. Deploy the infrastructure

```bash
terraform apply -var-file="dev.tfvars"
```

### 9. View outputs

```bash
terraform output
```

Available outputs include Managed Instance name, FQDN, SKU, vCores, storage, resource IDs, and managed identity information.

## Security Considerations

- SQL MI public data endpoint is disabled by default.
- TLS 1.2 is configured as the minimum supported version.
- The SQL admin password is supplied through a sensitive Terraform variable.
- Terraform state and plan files are excluded from GitHub.
- Environment-specific `.tfvars` files are excluded from source control.
- A system-assigned managed identity is configured.
- Network connectivity to the private endpoint requires appropriate Azure networking and DNS.

## Limitations and Future Enhancements

The initial configuration focuses on provisioning a standalone SQL Managed Instance.

Planned enhancements:

- Reusable Terraform modules
- Separate Dev, QA, and Prod state management
- Azure Storage remote Terraform backend
- Microsoft Entra ID administrator configuration
- Azure Monitor metrics and alerts
- Diagnostic settings and Log Analytics
- Private DNS and hybrid connectivity options
- CI/CD deployment with GitHub Actions or Azure DevOps
- SQL Managed Instance failover groups
- Additional security and policy controls

## References

- [Azure SQL Managed Instance documentation](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/)
- [Azure SQL MI Terraform Quickstart](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/instance-create-terraform)
- [HashiCorp AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)

## Disclaimer

This repository is a learning and demonstration project. Review networking, identity, resource sizing, cost, and security requirements before using it for production workloads.
