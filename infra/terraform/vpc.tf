###
# Utilizing terraform vpc module
###
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 2.70.0"

  name               = "demo-dev"
  cidr               = "10.0.0.0/28"
  azs                = ["eu-west-2a","eu-west-2b"]
  private_subnets    = ["10.0.0.0/29", "10.0.0.8/29"]
  public_subnets     = ["10.0.0.16/29", "10.0.0.24/29"]
  enable_nat_gateway = true
  single_nat_gateway = true
  tags               = {
    Environment = "demo"
    Owner = "Ravindra"
    ManagedBy = "Terraform"
    Destroy = true
  }
}
