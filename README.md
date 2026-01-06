# AWS-using-Terraform
To showcase real-world cloud engineering practices such as high availability, modular Infrastructure as Code (IaC)

---

## Architecture Overview

** Networking Layer (VPC):**
- Custom **VPC** spanning **2 Availability Zones**
- **1 Public Subnet** per AZ for the ALB
- **2 Private Subnets** per AZ for application servers and databases
- **Internet Gateway** for outbound traffic
- **NAT Gateways** for secure private subnet access
- **Route Tables** configured for public/private segregation

** Compute Layer:**
- **Auto Scaling Group (ASG)** running Amazon Linux 2 EC2 instances
- **Application Load Balancer (ALB)** distributing traffic across AZs
- **User Data script** bootstraps each EC2 instance with Nginx
- **AWS Systems Manager (SSM)** for secure instance management (no SSH keys)
- **IAM roles** granting least-privilege access to Secrets Manager

** Database Layer:**
- **Amazon RDS (MySQL)** deployed in private subnets
- **AWS Secrets Manager** securely stores database credentials
- Secrets and identifiers managed via **terraform.tfvars** (excluded from version control)

** Security & Monitoring:**
- **Security Groups** restricting access between tiers
- **CloudWatch** monitors Auto Scaling metrics and instance health
- **Route 53** + **AWS Certificate Manager (ACM)** provides HTTPS on a custom domain  
  (`https://justindemo.click`)

** Terraform Backend & State Locking:**
- **Remote backend** stored in **S3** for collaboration and persistence
- **DynamoDB table** enables state locking to prevent concurrent updates

---

## Project Structure


## Project Structure

```
├── main.tf                # Root configuration combining all modules
├── variables.tf           # Global variables
├── terraform.tfvars       # Sensitive data (excluded via .gitignore)
├── backend.tf             # Remote backend configuration (S3 + DynamoDB)
├── outputs.tf             # Terraform outputs (ALB DNS, RDS endpoint, etc.)
├── modules/
│   ├── acm/               # SSL/TLS certificate via AWS Certificate Manager
│   ├── compute/           # ALB, ASG, EC2 user data, IAM roles
│   ├── database/          # RDS + Secrets Manager
│   ├── monitoring/        # CloudWatch dashboard & scaling policies
│   ├── network/           # VPC, subnets, route tables, gateways
│   ├── route53/           # DNS records, registered domain
│   └── sns_notifications/ # SNS notifications for CloudWatch alarms
```

## Deployment Steps:

Initialize Terraform:

terraform init


## Validate configuration:

terraform validate


## Preview resources:

terraform plan


## Deploy infrastructure:

terraform apply


## Tear down resources:

terraform destroy
