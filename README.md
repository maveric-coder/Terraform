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

<img src = "/files/content/terraform_infra.gif">

In the diagram, we start off with Terraform configuration file, Terraform vars file, and other configuration files if created. 
<br><br>We would then plan and use those configuration files with Terraform to apply those configurations to our cloud provider, which would then in turn build our cloud environment and deploy our infrastructure with our resources.
<br><br>That information would then be sent back to Terraform where it would then write it to a Terraform state file, which is like a backup or snapshot of our successfully applied Terraform configuration.
<br><br>We can then either keep that Terraform.tfstate file locally, or we can use something like Terraform Cloud as the backend to store our state, or we can have teams of people manage the configuration.

