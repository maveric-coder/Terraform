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
```sh
terraform apply --auto-approve
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
  sensitive = true
  validation {
    condition = length(var.my-var) > 4
    error_message = "The string must of more than 4 characters"
  }

}
```
Varaible makes our code more veratile and reusable. To refernce a variable in the code `var.my-var`.
<br>We can declare multiple variables in a separate file having extension **.tfvars**
<br>With the use of validation feature we can validate the values of the variables and prompt some output incase the input value will not satisfy the declared condition.
<br> We can also decalre the value to be *sensitive* by this terraform will not show the values while executing it.

Varaible types:
<br>Base Types: int, string, boolean
<br>Complex Types: list, set, map, touple, object

*Output Values
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


## Terraform State file

It tracks the resources as in it tracks what resources have been deployed and what need to be deployed. It is very crucial for terraform to operate.
<br>When we execute `terraform destroy` command terraform looks in state file to destroy the resources.
<br>It helps terraform to calculate delta and new deployment plans.
<br>By default, state is stored in file called terraform.tfstate.
<br>Prior to any modification operation, Terraform refreshed tfstate file.
<br>Resource dependency metadata is also tracked via the state file.
<br>Helps boost deployment perfoemance by caching resource attributes for subsequent use.

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
  image = docker_image. terraform-centos. latest
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
``
We removed the resource from the state file and is not managed by terraform state file any more but the container will keep runnning.
```sh
terraform state
docker ps
```
#### Storing State files 


<img src = "/files/content/terraform-remote-state-storage.png"/>

For remote storage of State file there is a feature of state locking so that there will be no parallael execution.
<br>It also enables sharing of "output" values with other terraform configuration or code.


### Terraform Modules
* A module is a container for multiple resources that are used together.
* Every Terraform configuration has atleast one module, called root module which consists of code files in the main working directory.
* Modules can optionally take inputs and provide outputs to plug back into the main code.

```tf
module "my-vpc-module"{
  source = "./modules/vpc"
  version = "0.0.5"
  region = var.region
}
```

Acccessing module outpu in the main code

```tf
resource "aws_instance" "my-instance"{
  .....# some arguments
  subnet_id = module.my-vpc-module.subnet_id
}

