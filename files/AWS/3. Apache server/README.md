# Deploy Apache server with elastic IP

1. create VPC
2. create internet gateway
3. create custom route table
4. create a subnet
5. associate subnet with route table
6. create security group to allow port 22, 80, 443
7. create a network interface with an ip in the subnet that was created in step 4
8. assign an elastic IP to the netowrk interface created in step 7
9. create Ubuntu server and install/enable apache2