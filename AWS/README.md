# AWS

**Pre-requisites:**


* Terraform binary version should be greater than or equal to 0.13. [Install terraform](https://docs.digitalocean.com/reference/terraform/getting-started/)
* AWS CLI should be installed. `sudo apt-get install awscli`


<br>You will also need AWS Access Key and AWS Secret Access Key for configuring your AWS CLI profile used by S3 backend and ensure that your credentials allow you to create , upload and download objects from S3 buckets. As an alternate in lieu of AWS hardcoded credentials IAM roles can also be used.

Create the profile for our AWS CLIauthentication, which is set to be demo can be seen in `backend.tf` file
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