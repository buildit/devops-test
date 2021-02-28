###
# Utilizing terraform vpc module
###
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 2.70.0"

  name               = "demo-dev"
  cidr               = "10.0.0.0/28"
  azs                = ["eu-west-2a","eu-west-2b"]
  private_subnets    = ["10.0.0.0/26", "10.0.0.64/26"]
  public_subnets     = ["10.0.0.128/26", "10.0.0.192/26"]
  enable_nat_gateway = true
  single_nat_gateway = true
  tags               = {
    Environment = "demo"
    Owner = "Ravindra"
    ManagedBy = "Terraform"
    Destroy = true
  }
}
