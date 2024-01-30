# Basic execution

1. To see all the available commands to beused
```sh
terraform
```
2. Check terraform version
```sh
terraform version
```
3. Initialise our current working directory and will look/update needed plugins
```sh
terraform init
```
4. Terraform plan to see what is going to get created/changed
```sh
terraform plan
```

we can save the plan into a file by
```sh
terrafrom plan -out testplan
```
5. deploy the configuration
```sh
terraform apply
```

or
```sh
terraform applu --auto-approve
```

6. we can delete the deployed resources by
```sh
terraform destroy   
```
