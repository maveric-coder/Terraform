# Managing Variables in Terraform

In Terraform, managing configuration involves two key files: `variables.tf` and `terraform.tfvars`. They work together to define and assign values to variables used throughout your infrastructure code. Let's break down their roles:

**variables.tf:**

* **The Blueprint:** This file acts as the blueprint, defining the variables your Terraform configuration will use.
* **What's Included:** Each variable declaration specifies:
    * **Name:** A unique identifier used to reference the variable in your Terraform code (e.g., `resource_group_name`).
    * **Type:** Defines the data type the variable can hold (e.g., `string`, `number`, `list`).
    * **Description (Optional):** Provides a clear explanation of the variable's purpose (e.g., `Name of the resource group`).

**Example:**

```terraform
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Location of the resources"
}
```

**terraform.tfvars:**

* **The Value Provider:** This file supplies the actual values for the variables defined in `variables.tf`. It's often treated as sensitive information.
* **Key-Value Pairs:** Each line defines a variable name followed by an equal sign (`=`) and its corresponding value.

**Example:**

```
resource_group_name = "my-resource-group"
location            = "West US"
```

**Benefits of Separation:**

* **Reusability:** By using variables, you can create configurations that adapt to different environments by simply changing the values in `terraform.tfvars`.
* **Maintainability:** Keeping configuration logic separate from specific values improves code readability and maintainability.
* **Security:** Sensitive information like resource names or API keys are stored outside the main Terraform code, enhancing security practices.

**How it Works Together:**

1. **Define Variables:** You define variables in `variables.tf`, outlining the type of data they expect.
2. **Assign Values:** In `terraform.tfvars`, you assign specific values to those variables.
3. **Use in Code:** Your main Terraform configuration (e.g., `main.tf`) references the variable names, utilizing the provided values during resource creation.

**Key Points:**

* You can manage multiple `terraform.tfvars` files with different values for different environments.
* Terraform allows setting variable values through other methods like environment variables or command-line arguments, but `terraform.tfvars` is a common and convenient approach.

By understanding the roles of `variables.tf` and `terraform.tfvars`, you can create more flexible and secure Terraform configurations, making your infrastructure management more efficient.



## Using variables.tf and terraform.tfvars in Azure with Terraform

Here's an example demonstrating variables.tf and terraform.tfvars for creating a simple web app on Azure:

**Directory Structure:**

```
.
├── main.tf
├── variables.tf
└── terraform.tfvars
```

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

variable "app_service_plan_name" {
  type        = string
  description = "Name of the app service plan"
}

variable "app_name" {
  type        = string
  description = "Name of the web app"
}
```

**terraform.tfvars:**

```
resource_group_name = "my-resource-group"
location            = "West US"
app_service_plan_name = "my-app-service-plan"
app_name             = "my-web-app"
```

**main.tf:**

```terraform
# Configure Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Select Azure provider
provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Create App Service Plan
resource "azurerm_app_service_plan" "app_plan" {
  name                = var.app_service_plan_name
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

# Create Web App
resource "azurerm_app_service" "web_app" {
  name                = var.app_name
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  app_service_plan_id  = azurerm_app_service_plan.app_plan.id
  # ... other web app configurations
}
```

**Explanation:**

* `variables.tf` defines the variables used in the configuration.
* `terraform.tfvars` provides the actual values for those variables. This allows separation of configuration and sensitive information.
* `main.tf` references the variables and uses them to create resources in Azure.

**Benefits of using variables.tf and terraform.tfvars:**

* **Reusability:** Variables make configurations reusable across environments.
* **Maintainability:** Code separation improves maintainability.
* **Security:** Sensitive information like resource names are stored separately.

**Remember:**

* Update `terraform.tfvars` with your desired values.
* Run `terraform init` to initialize Terraform.
* Run `terraform plan` to preview the changes.
* Run `terraform apply` to create the resources in Azure.
