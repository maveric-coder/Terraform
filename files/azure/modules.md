# Modules

## Understanding the Structure

Before we dive into the code, let's understand the basic structure of a Terraform module:

* **Module Directory:** Contains the configuration files for the module.
    * `main.tf`: Defines the resources and outputs.
    * `variables.tf`: Defines the input variables.
    * `outputs.tf`: Defines the output values.
* **Root Module:** The main Terraform file where you use the module.

## Example: Creating a Virtual Network Module

### Module Directory Structure

```
modules/
├── vnet/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
```

### Module Code

#### `modules/vnet/main.tf`
```terraform
resource "azurerm_virtual_network" "main" {
  name                = var.name
  address_space      = var.address_space
  location           = var.location
  resource_group_name = var.resource_group_name
}
```

#### `modules/vnet/variables.tf`
```terraform
variable "name" {
  type        = string
  description = "Name of the virtual network"
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
}

variable "location" {
  type        = string
  description = "Location of the virtual network"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}
```

#### `modules/vnet/outputs.tf`
```terraform
output "id" {
  value = azurerm_virtual_network.main.id
}
```

### Root Module

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

module "vnet" {
  source = "./modules/vnet"

  name                = "my-vnet"
  address_space      = ["10.0.0.0/16"]
  location           = "West US"
  resource_group_name = "my-resource-group"
}
```

## Explanation

* The `modules/vnet` directory contains the configuration for the virtual network module.
* The `main.tf` file defines the `azurerm_virtual_network` resource, using variables for configuration.
* The `variables.tf` file defines the input variables for the module.
* The `outputs.tf` file defines the output value, which is the ID of the virtual network.
* The root module uses the `module` block to instantiate the `vnet` module and provides the required input variables.

### Key Points

* Modules promote code reusability and organization.
* Input variables allow customization of module behavior.
* Output values provide access to module resources.
* Consider using additional configuration files like `locals.tf` for complex logic.


## A More Complex Example: Three-Tier Application Architecture

Let's create a more complex scenario where we deploy a three-tier application architecture on Azure using multiple modules. The architecture will consist of a virtual network, a subnet, a virtual machine for the web tier, a virtual machine for the app tier, and a virtual machine for the database tier.

### Module Structure

```
modules/
├── vnet/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── subnet/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── vm/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── app/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

### Module Code

#### `modules/vnet/main.tf`
```terraform
resource "azurerm_virtual_network" "main" {
  name                = var.name
  address_space      = var.address_space
  location           = var.location
  resource_group_name = var.resource_group_name
}
```

#### `modules/subnet/main.tf`
```terraform
resource "azurerm_subnet" "main" {
  name                 = var.name
  address_prefix       = var.address_prefix
  virtual_network_id   = var.virtual_network_id
}
```

#### `modules/vm/main.tf`
```terraform
resource "azurerm_virtual_machine" "main" {
  name                 = var.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  # ... other VM configurations
}

resource "azurerm_network_interface" "main" {
  name                 = var.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  ip_configuration {
    name                          = "primary"
    subnet_id                    = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
```

#### `modules/app/main.tf`
```terraform
# Module to deploy the entire application (combines other modules)
# ...
```

### Root Module

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

module "vnet" {
  source = "./modules/vnet"
  # ... variables
}

module "subnet_web" {
  source = "./modules/subnet"
  # ... variables, including vnet_id from vnet module
}

module "subnet_app" {
  source = "./modules/subnet"
  # ... variables, including vnet_id from vnet module
}

module "subnet_db" {
  source = "./modules/subnet"
  # ... variables, including vnet_id from vnet module
}

module "web_vm" {
  source = "./modules/vm"
  # ... variables, including subnet_id from subnet_web module
}

module "app_vm" {
  source = "./modules/vm"
  # ... variables, including subnet_id from subnet_app module
}

module "db_vm" {
  source = "./modules/vm"
  # ... variables, including subnet_id from subnet_db module
}

module "app" {
  source = "./modules/app"
  # ... variables
}
```

### Explanation

* We have created modules for virtual network, subnet, and virtual machine.
* The `app` module can be used to orchestrate the deployment of the entire application.
* Dependencies between modules are managed by passing output values (like `vnet_id`) as input variables to dependent modules.
* This structure promotes code reusability, modularity, and maintainability.

**Note:** This is a simplified example. A real-world application would involve more complex configurations, security groups, load balancers, and other components.

By breaking down the infrastructure into smaller, manageable modules, you can create more complex and scalable solutions while improving code organization and reusability.


## Module Versioning and Terraform Cloud

### Module Versioning
Module versioning is crucial for maintaining compatibility and managing changes. Terraform supports a basic form of versioning through directory structure. You can create different versions of a module by placing them in separate directories.

**Example:**
```
modules/
├── vnet/
│   ├── v1/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── v2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ...
└── subnet/
    ├── ...
```

In the root module, you can specify the desired module version:

```terraform
module "vnet" {
  source = "./modules/vnet/v2"
  # ...
}
```

**Limitations:**
* This approach lacks advanced version control features like semantic versioning.
* It doesn't provide a centralized repository for modules.

### Terraform Cloud for Collaboration
Terraform Cloud offers a platform for collaborative infrastructure management, including module versioning, registry, and workspaces.

**Key features:**

* **Module Registry:** Store and version your modules in a centralized location.
* **Workspaces:** Create isolated environments for different environments (dev, staging, prod).
* **Collaborators:** Invite team members to collaborate on modules and workspaces.
* **VCS Integration:** Connect your Terraform code to a version control system (Git).
* **Remote State Management:** Securely store Terraform state in the cloud.

**Example:**
* Create a Terraform Cloud organization.
* Create a private module registry within the organization.
* Push your module code to the registry, specifying versions.
* Create workspaces for different environments.
* Configure remote state management for each workspace.
* Collaborate with team members by inviting them to the organization and granting appropriate permissions.

**Benefits:**
* Improved collaboration and code sharing.
* Enhanced module management and version control.
* Centralized configuration and state management.
* Increased security and compliance.

### Additional Considerations
* **Terraform Registry:** Consider using the public Terraform Registry for community-contributed modules.
* **Module Testing:** Write unit tests for your modules to ensure quality and compatibility.
* **CI/CD Integration:** Integrate Terraform Cloud with your CI/CD pipeline for automated deployments.
* **Cost Management:** Be aware of the pricing for Terraform Cloud.

By leveraging module versioning and Terraform Cloud, you can significantly enhance your infrastructure management practices and promote collaboration within your team.
 

