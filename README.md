# Terraform

Terraform is an infrastructure as code tool that lets you build, change, and version cloud and on-prem resources safely and efficiently.

It is a tool for building, changing,and versioning infrastructure safely and efficiently, whether it be locally or in the cloud. 
You can manage existing and popular service providers, as well as custom in-house solutions. This includes low-level components, such as compute instances, storage, networking, as well as high-level components, such as DNS entries and SaaS features, as well as many other components.

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
```sh
terraform init
```
It initializes the working directory that contains our terraform code.
<br>It also:
<br>**--> downloads ancialliary components - modules and plugins** from default registry/librbay or custom registry path and it caches it in our local machine, incase new plugins are available it will update those by default. 
<br>**--> Sets up backend** - Sets the backend for storing terraform state file.

```sh
terrform plan
```
Reads the code and then creates and shows "plan" of execution/deployment/
<br>Note: This command does not deploy anything. Consider this as a read-only command.
<br><br>It allows the users to "review" the action plan before executing anything
<br><br>At this stage, authentication credentials are used to connect to the infrastructutre, if required.


```sh
terraform apply
```
Deploys the intructions and statements in the code.
<br>It updates the deployment state tracking mechanism file (state file) terraform.tfstate is the default state file.

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
}
```
Varaible makes our code more veratile and reusable. To refernce a variable in the code `var.my-var`.
### Terraform State file

It tracks the resources as in it tracks what resources have been deployed and what need to be deployed. It is very crucial for terraform to operate.
<br>When we execute `terraform destroy` command terraform looks in state file to destroy the resources.
<br>It helps terraform to calculate delta and new deployment plans.



