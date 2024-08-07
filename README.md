# Terraform

Terraform is an infrastructure as code tool that lets you build, change, and version cloud and on-prem resources safely and efficiently.

It is a tool for building, changing,and versioning infrastructure safely and efficiently, whether it be locally or in the cloud. 
You can manage existing and popular service providers, as well as custom in-house solutions. This includes low-level components, such as compute instances, storage, networking, as well as high-level components, such as DNS entries and SaaS features, as well as many other components.

Plain text files with .tf extension are where code in terraform language is stored. We can also use a json variant of the language wguch uses .tf.json file extension.

### How does Terraform work?

Terraform creates and manages resources on cloud platforms and other services through their application programming interfaces (APIs). Providers enable Terraform to work with virtually any platform or service with an accessible API.
<img src = "/files/content/terraform.png">


***The core Terraform workflow consists of three stages:***

**Write:** You define resources, which may be across multiple cloud providers and services. For example, you might create a configuration to deploy an application on virtual machines in a Virtual Private Cloud (VPC) network with security groups and a load balancer.

**Plan:** Terraform creates an execution plan describing the infrastructure it will create, update, or destroy based on the existing infrastructure and your configuration.

**Apply:** On approval, Terraform performs the proposed operations in the correct order, respecting any resource dependencies. For example, if you update the properties of a VPC and change the number of virtual machines in that VPC, Terraform will recreate the VPC before scaling the virtual machines.

<img src = "/files/content/terraform_stages.png" >

<img src = "/files/content/terraformflow.jpg" height="450" width="800">

## Terraform Architecture

<img src = "/files/content/terraform_infra.gif" height="450" width="800">

In the diagram, we start off with Terraform configuration file, Terraform vars file, and other configuration files if created. 
<br><br>We would then plan and use those configuration files with Terraform to apply those configurations to our cloud provider, which would then in turn build our cloud environment and deploy our infrastructure with our resources.
<br><br>That information would then be sent back to Terraform where it would then write it to a Terraform state file, which is like a backup or snapshot of our successfully applied Terraform configuration.
<br><br>We can then either keep that Terraform.tfstate file locally, or we can use something like Terraform Cloud as the backend to store our state, or we can have teams of people manage the configuration.

### Basic Terraform Commands
1. terraform init
```sh
terraform init
```
It initializes the working directory that contains our terraform code.
<br>It also:
<br>**--> downloads ancialliary components - modules and plugins** from default registry/librbay or custom registry path and it caches it in our local machine, incase new plugins are available it will update those by default. 
<br>**--> Sets up backend** - Sets the backend for storing terraform state file.

2. terraform plan
```sh
terrform plan
```
Reads the code and then creates and shows "plan" of execution/deployment/
<br>Note: This command does not deploy anything. Consider this as a read-only command.
<br><br>It allows the users to "review" the action plan before executing anything
<br><br>At this stage, authentication credentials are used to connect to the infrastructutre, if required.
```sh
terraform plan -out <plan_name> # Output a deployment plan
```
```sh
terraform plan -destroy #Output a destroy plan
```

3. terraform apply

```sh
terraform apply
```
```sh
terraform apply --auto-approve
```
Deploy a specific plan
```sh
terraform apply <plan_name> 
```
Deploy changes to a targated resource
```sh
terraform apply -target=<resource_name>
```
Pass a variable via the command-line
```sh
terraform apply -var my_variable=<variable>
```
Deploys the intructions and statements in the code.
<br>It updates the deployment state tracking mechanism file (state file) terraform.tfstate is the default state file.

4. terraform destroy
   
```sh
terraform destroy
```
It looks at the recorded, stored state file created during deployment and destroys all resources created by our code.
<br>Should be used with caution, as it is a non-reversible command. Take backup and be sure that we want to delete the infrastructure.

### Basic Terraform code

* Declaring Provider
```tf
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAYH6OBDUTYJ2D4O66"
  secret_key = "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"
}
```
Terraform uses plugin and make API calls with different cloud providers to validate and execute the commands.
<br>In this case our provider is **aws**

* Deploying VPC
```tf
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "production"
  }
}
```
In the above snippet we have defined a VPC to be created with the name **prod-vpc** and added a tag - production.

* Data
```tf
data "aws_instance" "my-vm" {
  instance_id = "i-012321311asad320"
}
```
A data source block fetches and tracks data of an existing resource whereas resource block will create/deploy a new resource.

```tf
data.aws_instance.my-vm.instance_id
```

* Declaring Variable
```tf
variable "my-var" {
  description = "My Test Variable"
  type = string
  default = "hello world"
  sensitive = true
  validation {
    condition = length(var.my-var) > 4
    error_message = "The string must of more than 4 characters"
  }

}
```
The name of a variable can be any valid identifier except for *source,version, providers, count, for_each, lifecycle, pends_on, and locals*<br>
Varaible makes our code more versatile and reusable. To refernce a variable in the code `var.my-var`.
<br>We can declare multiple variables in a separate file having extension **.tfvars**
<br>With the use of validation feature we can validate the values of the variables and prompt some output incase the input value will not satisfy the declared condition.
<br> We can also decalre the value to be *sensitive* by this terraform will not show the values while executing it.

Varaible types:
<br>Base Types: int, string, boolean
<br>Complex Types: list, set, map, touple, object

* Environment Variables

Terraform searches the environment for environment variables named TF_VAR_ followed by the name of the variable.
```sh
export TF_VAR_image_id = ami-abc12345
terraform plan
```
Terraform matches the variable name exactly as given in configuration on operating systems where the environment variable is case sensitive. The requirement environment variable name usually includes a mix of upper and lowercase letters, like an example above.

* Output Values
```tf
resource "aws_s3_bucket" "my_69_bucket" {
  bucket = "my-69-bucket"

  tags = {
    Name        = "bucket69"
    Environment = "Dev"
  }
}

output "s3bucketOutput" {
    value = aws_s3_bucket.my_69_bucket
}
```
Output values are shown on the shell aster running terraform apply.
<br>Output values are like return values that we want to track after a successful terraform deployment.

* Local Variable

```tf
locals {
  service_name = "test"
  owner = "test team"
}

resource "aws_instance" "test_instance" {
  #...
  tags = local.service_name
}
```
A set of related Local values can be declared together in a single block. <br>The expressions are not limited to literal constraints; they can reference other values in the module.


When a local value is declared, we can refernce it in expression as local.<name>
<br>Local values can only be accessed in expressions within the module where they are declared.


## Terraform State file

It tracks the resources as in it tracks what resources have been deployed and what need to be deployed. It is very crucial for terraform to operate.
<br>When we execute `terraform destroy` command terraform looks in state file to destroy the resources.
<br>It helps terraform to calculate delta and new deployment plans.
<br>By default, state is stored in file called terraform.tfstate.
<br>Prior to any modification operation, Terraform refreshes tfstate file.
<br>Resource dependency metadata is also tracked via the state file.
<br>Helps boost deployment performance by caching resource attributes for subsequent use.

### Terraform State command

Terraform State command is a utility for manipulating and reading the Terraform state file.
<br>Few scenarios:
* Advanced state management
* Manually remove a resource from Terraform State file so that it's not managed by Terraform
* Listing out tracked resources and their details(via state and list sub-commands)

|Terraform SubState command|Usage|
|----|----|
|terraform state list|List out all resources tracked by Terraform State file|
|terraform state rm|Delete a resouce from the Terrafrom State file|
|terraform state show|Show details of a resource tracked in the Terraform State file.|


Create a main.tf file to deploy docker container and see substate command in action
```tf
# Configure the Docker provider
provider "docker" {}
#Image to be used by container 

resource "docker_image" "terraform-centos" {
  name = "centos:7"
  keep_locally = true
｝

# Create a container
resource "docker_container" "centos" {
  image = docker_image.terraform-centos.latest
  name = "terraform-centos"
  start = true
  command = ["/bin/sleep", "500"]

}
```

```sh
terraform state
```
We can see all the containers and resources being managed by Terraform state file.
```sh
docker ps
```
All the running containers are lsited.
```sh
terraform state show docker_container.centos
```
This command shows all the details for the container named docker_container.centos
```sh
terraform state rm docker_container.centos
```
We removed the resource from the state file and is not managed by terraform state file any more but the container will keep runnning.
```sh
terraform state
docker ps
```
#### Storing State files 


<img src = "/files/content/terraform-remote-state-storage.png"/>

For remote storage of State file there is a feature of state locking so that there will be no parallael execution.
<br>It also enables sharing of "output" values with other terraform configuration or code.


## Terraform Modules
* A module is a container for multiple resources that are used together.
* Every Terraform configuration has atleast one module, called root module which consists of code files in the main working directory.
  * Root modules - We need atleast one root module.
  * Child modules - Modules that are called by root module.
  * Published modules - Modules that are loaded from private or public repository
* Modules can optionally take inputs and provide outputs to plug back into the main code.
* A module can consist of a collection of .tf as well as .tf.json files kept together in a directory.

```tf
module "my-vpc-module"{
  source = "./modules/vpc"
  version = "0.0.5"
  region = var.region
}
```

Acccessing module output in the main code

```tf
resource "aws_instance" "my-instance"{
  .....# some arguments
  subnet_id = module.my-vpc-module.subnet_id
}
```

* 8 Module Source types:
  1. GitHub
  2. Local Paths
    ```tf
    module "consul" {
      source = "./consul"
    }
    ```
    A local path must begin with *./* or *../* to indicate that it is indeed a local path. Local path are not installed in the same sense as other sources.

  3. Terraform Registry
    ```tf
    module "consul" {
      source = "hashicorp/consul/aws"
      version = "0.1.0"
    }
    ```
  4. Bitbucket
  5. Generic Git, Mercurial Repositories
  6. HTTP URLs
  7. S3 Buckets
  8. GCS Buckets

## Terraform Built-in Functions

* Terrraform comes with pre-packaged functions and user-defined functions are not allowed.

```tf
variable "project-name"{
  type = string
  default = "prod"
}

resource "aws_vpc" "my-vpc"{
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = join("-",["terraform", var.project-name])
  }
}
```

[Terraform Functions](https://developer.hashicorp.com/terraform/language/functions)


### Type Constraints - Terraform Variables

* Type constriants control the type of variable values

* Primitive - Single type value : number, string, bool
* Complex -  Multiple types in a single variable : list, touple, map, object
  
  * Collection - allows multiple values of one primitive type to be grouped together : list, map, set (having values of same data type)
    ```tf
    variable "training"{
      type = list(string)
      default = ["ABC", "IN"]
    }
    ```
    
  * Structural - allows multiple values of different data types to be grouped together : Object, touple, set



* any - it is a placeholder for primitive type yet to be decided and its actual type will be decided at runtime.


### Terraform fmt

* Formats Terraform code for readability
* Helps in keeping code consistent

```tf
terraform fmt
```

### Terraform Taint 

* Taints a resource, forcing it to be destroyed and recreated
* Modifies the state file, which causes the recreation workflow
* Tainting a resource may cause other resources to be modified
* It is not possible to taint the entire module. Instead, each resource within the module must be tainted separately.

```tf
terraform taint <resource_address>
```
### Backend Configuration

A backend defines where Terraform stores its state data files.

Terraform uses persisted state data to keep track of the resources it manages. Most non-trivial Terraform configurations either integrate with Terraform Cloud or use a backend to store state remotely. This lets multiple people access the state data and work together on that collection of infrastructure resources.
<br><br>By default, Terraform uses a backend called local, which stores state as a local file on disk. 

```tf
terraform {
  backend "remote" {
    organization = "example_corp"

    workspaces {
      name = "my-app-prod"
    }
  }
}
```
There are some important limitations on backend configuration:
* A configuration can only provide one backend block.
* A backend block cannot refer to named values (like input variables, locals, or data source attributes).
* You cannot reference values declared within backend blocks elsewhere in the configuration. Refer to References to Resource Attributes for more details.

Local example configuration:
```tf
terraform {
  backend "local" {
    path = "/path/to/terraform.tfstate"
  }
}
```
path - the path to tfstate file
<br>workspace_dir - the path to non-default workspace

We can create a separate backend script
```tf
# backend.hcl
workspaces { name = "workspace" }
hostname = "app.terraform.io"
organisation = "company"
```
then run the backend script with terraform init
```sh
terraform init -backend-config=backend.hcl
```

S3 backend configuration
```tf
terraform {
  backend "s3" {
    bucket = "mybucket"
    key = "path/to/my/key"
    region = "us-east-1"
  }
}
```
S3 bucket permissions: 
  * s3:ListBucket
  * s3:GetObject
  * s3:PutObject
  

### Terraform Import

* Maps existing resources to Terraform using "ID"
* "ID" is dependent on the underlying vendor, for example to import AWS EC2 instance we'll have to provide its instance ID.
* Importing the same resource to multiple terraform codes can cause unknown behaviour and it is not recommended.

```tf
terraform import <resource_address> ID
```

### Terraform Workspace (CLI)

* The terraform workspaces are alternate state files within the same working directory
* Terraform starts with a single workspace that is always called default. It cannot be deleted

```tf
terraform workspace new <WORKSPACE NAME> --> create a new Workspace
terraform workspace select <WORKSPACE NAME> --> Select a workspace
```
It is helpful in cases where we need to test changes usinfg a parallel, distinct copy of infrastructure. It can also be modelled against branches in version control such as Git.
<br>Workspaces are meant to share resources and to help enable collaboration.
<br>Access to a workspace name is provided through the ${terraform.workspace} variable.

## Reading Values from Azure Key Vault in Terraform

### Understanding the Approach

Terraform doesn't directly access secrets within Azure Key Vault for security reasons. However, it can retrieve the secret value using the `data` resource. Here's a breakdown of the steps:

1. **Identify the Key Vault:** Determine the name and resource group of the Key Vault where the secret is stored.
2. **Use `data` resource:** Utilize the `azurerm_key_vault_secret` data source to fetch the secret value.

### Terraform Code Snippet

```terraform
data "azurerm_key_vault" "example" {
  name                = "your-key-vault-name"
  resource_group_name = "your-resource-group"
}

data "azurerm_key_vault_secret" "example" {
  name         = "your-secret-name"
  key_vault_id = data.azurerm_key_vault.example.id
}

output "secret_value" {
  value = data.azurerm_key_vault_secret.example.value
}
```

### Explanation

* **`data "azurerm_key_vault" "example"`:** This block fetches information about the Key Vault, including its ID, which is used in the next step.
* **`data "azurerm_key_vault_secret" "example"`:** This block retrieves the secret value based on its name and the Key Vault ID.
* **`output "secret_value"`:** This block outputs the retrieved secret value for reference.

### Important Considerations

* **Permissions:** Ensure the service principal associated with your Terraform configuration has necessary permissions to access the Key Vault and read secrets.
* **Security:** Avoid hardcoding secrets in Terraform code. Always use Key Vault for secure storage.
* **Error Handling:** Implement error handling to gracefully handle situations where the secret is not found.
* **Secret Rotation:** Regularly rotate secrets to enhance security.
* **Terraform State:** Protect your Terraform state file as it contains sensitive information.

### Additional Tips

* Consider using environment variables or configuration files to store the Azure credentials required for Terraform execution.
* Use Terraform modules to encapsulate common Key Vault configurations.
* Implement proper error handling and logging in your Terraform code.


## Error Handling in Terraform When Retrieving Secrets from Azure Key Vault

When retrieving secrets from Azure Key Vault in Terraform, it's crucial to implement error handling to gracefully handle potential issues. This could include scenarios like the secret not existing, insufficient permissions, or network errors.

### Understanding Potential Errors

* **Secret Not Found:** The specified secret might not exist in the Key Vault.
* **Insufficient Permissions:** The service principal associated with your Terraform configuration might lack necessary permissions to access the Key Vault or read secrets.
* **Network Errors:** Network connectivity issues can prevent successful retrieval of the secret.

### Implementing Error Handling

Terraform provides the `try` and `catch` blocks for error handling. We can use these to handle exceptions and provide informative messages.

```terraform
data "azurerm_key_vault" "example" {
  name                = "your-key-vault-name"
  resource_group_name = "your-resource-group"
}

try {
  data "azurerm_key_vault_secret" "example" {
    name         = "your-secret-name"
    key_vault_id = data.azurerm_key_vault.example.id
  }
} on error {
  output "error_message" {
    value = "Error retrieving secret: ${error.message}"
  }
}

output "secret_value" {
  value = try { data.azurerm_key_vault_secret.example.value } catch * { "" }
}
```

### Explanation

* **`try` block:** This block contains the code that might potentially raise an error. In this case, it's the `data "azurerm_key_vault_secret" "example"` block.
* **`on error` block:** This block is executed if an error occurs within the `try` block. Here, we're creating an output `error_message` to display the error message for debugging purposes.
* **`output "secret_value"`:** This block tries to output the secret value if it was successfully retrieved. If an error occurs, an empty string is returned.

### Additional Considerations

* **Custom Error Handling:** You can create custom error messages based on specific error types or conditions.
* **Retry Logic:** For transient errors like network issues, consider implementing retry logic using `for_each` and `count` meta-arguments.
* **Logging:** Use Terraform's logging capabilities to record error details for analysis.
* **Alerting:** Integrate with monitoring tools to send notifications for critical errors.


