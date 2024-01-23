# Configuring S3 bucket for remotely storing terraform state file.

**Pre-requisites:**

1. Docker should be pre-installed and accessible via default Terraform docker provider mechanism. [Install docker](https://docs.docker.com/engine/install/ubuntu/)
2. Terraform binary version should be greater than or equal to 0.13. [Install terraform > v0.13](https://docs.digitalocean.com/reference/terraform/getting-started/)
3. AWS CLI should be installed. `sudo apt-get install awscli`


<br>You will also need AWS Access Key and AWS Secret Access Key for configuring your AWS CLI profile used by S3 backend and ensure that your credentials allow you to create , upload and download objects from S3 buckets. As an alternate in lieu of AWS hardcoded credentials IAM roles can also be used.
