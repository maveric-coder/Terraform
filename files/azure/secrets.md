# Secrets in Terraform

## Using Environment Variables for Secret Values in Terraform with Azure

### Understanding the Approach
This method involves storing sensitive information like API keys, passwords, or other secrets in environment variables. Terraform can then access these values during execution.

### Code Example

**variables.tf:**

```terraform
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Location of the resources"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "storage_account_key" {
  type        = string
  description = "Storage account key"
  sensitive  = true
}
```

**main.tf:**

```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name     = azurerm_resource_group.example.name
  location                = azurerm_resource_group.example.location
  account_replication_type = "LRS"
  primary_access_key = var.storage_account_key
}
```

### Setting Environment Variables

To set the environment variables, you can use your shell's capabilities (e.g., Bash, PowerShell). For example, in Bash:

```bash
export TF_VAR_resource_group_name="myresourcegroup"
export TF_VAR_location="West US"
export TF_VAR_storage_account_name="mystorageaccount"
export TF_VAR_storage_account_key="your_super_secret_key"
```

**Note:** Replace the placeholder values with your actual values.

### Running Terraform

When you run `terraform init` and `terraform apply`, Terraform will automatically pick up the values from the environment variables and assign them to the corresponding variables in your configuration.

### Important Considerations:

* **Security:** While using environment variables is convenient, it's essential to protect the sensitive information they contain. Avoid committing the environment variable names or values to version control.
* **Multiple Environments:** For managing multiple environments, consider using different environment variable prefixes or using configuration management tools like Ansible or Puppet.
* **Terraform Cloud:** If you're using Terraform Cloud, you can securely manage variables and their values within the platform.
* **Sensitive Data:** Always mark sensitive variables as `sensitive` in your `variables.tf` to prevent accidental exposure.

### Additional Tips:

* Use descriptive variable names to improve code readability.
* Consider using default values for optional variables in `variables.tf`.
* Leverage Terraform's `sensitive` attribute for variables containing sensitive information.
* Explore using configuration management tools for managing environment variables and Terraform configuration.



## Reading a Secret from Azure Key Vault Using a Data Block in Terraform

**Understanding the Approach:**

This method leverages Terraform's data block to fetch the secret value directly from Azure Key Vault. However, it's crucial to note that the secret value will be stored in the Terraform state file in plain text. For production environments, consider using environment variables or dedicated secret management tools.

### Code Snippet

```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "key_vault_name" {
  type        = string
  description = "Name of the key vault"
}

variable "secret_name" {
  type        = string
  description = "Name of the secret"
}

data "azurerm_key_vault" "example" {
  name                = var.key_vault_name
  resource_group_name = "your-resource-group"
}

data "azurerm_key_vault_secret" "example" {
  name         = var.secret_name
  key_vault_id = data.azurerm_key_vault.example.id
}

resource "azurerm_storage_account" "example" {
  name                     = "mystorageaccount"
  resource_group_name     = "myresourcegroup"
  location                = "West US"
  account_replication_type = "LRS"
  primary_access_key = data.azurerm_key_vault_secret.example.value
}
```

### Explanation

1. **Import the `azurerm` provider:** This is necessary for interacting with Azure resources.
2. **Define variables:** `key_vault_name` and `secret_name` are defined as variables to make the configuration flexible.
3. **Fetch Key Vault information:** The `data "azurerm_key_vault" "example"` block retrieves information about the specified key vault.
4. **Read the secret:** The `data "azurerm_key_vault_secret" "example"` block fetches the secret value from the key vault.
5. **Use the secret:** The `azurerm_storage_account` resource uses the retrieved secret as the `primary_access_key`.

### Important Considerations

* **Security:** The secret value will be stored in the Terraform state file in plain text. Avoid using this approach in production environments.
* **Alternatives:** Consider using environment variables, HashiCorp Vault, or Azure App Configuration for more secure secret management.
* **Data Source Limitations:** The `data "azurerm_key_vault_secret"` data source might have limitations, such as not supporting secret versions or specific key vault configurations.

By understanding these limitations and following best practices, you can effectively use this approach for development or testing purposes.

## Using HashiCorp Vault for Secret Values in Terraform with Azure

### Understanding the Approach

This method involves storing secrets in HashiCorp Vault and retrieving them during Terraform execution using the `vault` provider. This provides a more secure and centralized approach to managing secrets compared to environment variables.

### Prerequisites

* A running HashiCorp Vault instance with appropriate policies and secrets.
* Terraform installed and configured with the `hashicorp/vault` provider.

### Terraform Configuration

```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "vault" {
  address = "https://your-vault-address:8200"
  token  = "your-vault-token"
}

data "vault_generic_secret" "example" {
  path = "secret/data/my-secret"
}

resource "azurerm_resource_group" "example" {
  name     = "myresourcegroup"
  location = "West US"
}

resource "azurerm_storage_account" "example" {
  name                     = "mystorageaccount"
  resource_group_name     = azurerm_resource_group.example.name
  location                = azurerm_resource_group.example.location
  account_replication_type = "LRS"
  primary_access_key = data.vault_generic_secret.data.data["my-secret"]
}
```

### Explanation

* **Import necessary providers:** Import the `azurerm` and `vault` providers.
* **Configure Vault provider:** Provide the Vault address and authentication token.
* **Retrieve secret:** Use the `data "vault_generic_secret"` data source to fetch the secret from Vault.
* **Utilize secret in Azure resource:** Use the retrieved secret value in the `azurerm_storage_account` resource.

### Additional Considerations

* **Vault Authentication:** Explore different authentication methods like AppID, AWS IAM, or Kubernetes auth.
* **Secret Rotation:** Leverage Vault's secret rotation capabilities.
* **Access Controls:** Implement strict access controls within Vault.
* **Vault Policies:** Define policies to control access to secrets.
* **Security Best Practices:** Follow best practices for storing and managing Vault tokens.

### Security Implications

* Storing the Vault token in plain text in the configuration is not recommended for production environments. Consider using environment variables or secure storage mechanisms.
* Implement robust access controls for Vault to protect your secrets.

### Best Practices

* Use dedicated secret management tools like HashiCorp Vault for storing and managing secrets.
* Avoid hardcoding secrets in Terraform configurations.
* Implement strict access controls to protect your secrets.
* Regularly rotate secrets.
* Consider using Terraform Cloud for secure secret management.
