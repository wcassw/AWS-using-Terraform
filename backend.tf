terraform {
  backend "s3" {
    bucket         = "terraform-state-buckt"
    key            = "3-tier-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
