## Basic Deployment and checks
Initialize the terraform to check for needed plugins and modules
```sh
terraform init
```
To verify that our configuration is formatted properly
```sh
terraform fmt
```

And validate it by running
```sh
terraform validate
```

Now run Terraform Plan to validate the created storage
```sh
terraform plan
```

Deploy the container and verify
```sh
terraform apply --auto-approve
```

We can see the deployed resources by below command, it will inspect the current state file
```sh
terraform show
```
Similarly, we can get to see the list of resources being managed by
```sh
terraform state list
```

Now, change some part of the already existing resource eg. AMI, instance_type.
```sh
terraform plan
```
We can see all the changes that will be done.

```sh
terraform apply
```
All the changes will be applied.
```sh
terraform show
```
will show the new configuration for the server


Destroy the created container (make sure the container is in stopped state, or else it will fail and ask to run using -force)
```sh
terraform destroy --auto-approve
```

## Input variables

Create the variables.tf file.

Now we will replace the tag name with the variable created earlier.
```tf
resource "aws_instance" "app_server" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
```

Apply the configuration now
```sh
terraform apply
```

Now, if we will try to observe the tag name for the server, we will observer that it took default value as we did not pass a value while applying the configuration
```sh
terraform show
```
We will pass some values 
```sh
terraform apply -var "instance_name=prod"
```