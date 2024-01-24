# Configuring S3 bucket for remotely storing terraform state file.

**Pre-requisites:**

1. Docker should be pre-installed and accessible via default Terraform docker provider mechanism. [Install docker](https://docs.docker.com/engine/install/ubuntu/)
2. Terraform binary version should be greater than or equal to 0.13. [Install terraform](https://docs.digitalocean.com/reference/terraform/getting-started/)
3. AWS CLI should be installed. `sudo apt-get install awscli`


<br>You will also need AWS Access Key and AWS Secret Access Key for configuring your AWS CLI profile used by S3 backend and ensure that your credentials allow you to create , upload and download objects from S3 buckets. As an alternate in lieu of AWS hardcoded credentials IAM roles can also be used.

## Follow the below steps

1. Create the profile for our AWS CLIauthentication, which is set to be demo can be seen in `backend.tf` file
   ```sh
   aws --profile demo configure
   ```
   ```sh
   AWS Access Key ID:
   AWS Secret Access Key:
   Default region name: us-east-1
   ```
   You will get access key and secret key Account-> Security Credentials -> Access Keys -> Create access Key -> AWS CLI
   <br>Copy the Access key ID and secret key in the AWS CLI

2. Create a bucket using the newly created profile and select a bucket name
   ```sh
   aws --profile demo s3api create-bucket --bucket testbucket69696
   ```
   
3. Verify the bucket name in `backend.tf` file
   
4. Initialize the terraform to check for needed plugins and modules
   ```sh
   terraform init
   ```
   
5. Now run Terraform Plan to validate the created storage
   ```sh
   terraform plan
   ```

6. Deploy the container and verify
   ```sh
   terraform apply --auto-approve
   ```
7. Verify the existence of the NGINX container by visiting http://<public IP>:8081 in your web browser or running docker ps to see the container.
   ```sh
   docker ps
   ```

8. Destroy the created container (make sure the container is in stopped state, or else it will fail and ask to run using -force)
   ```sh
   terraform destroy --auto-approve
   ```
