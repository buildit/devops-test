# Local vars specific to this execution
locals {
  env = read_terragrunt_config("${get_parent_terragrunt_dir()}/env-config/env.hcl")
}

# Terraform source code location (can be a git repo too)
terraform {
  source = "${get_parent_terragrunt_dir()}/../infra/terraform/alb//"
}

# Include config from parent folder
include {
  path = find_in_parent_folders()
}

# Create dependency
dependency "network" {
  config_path = "../network"
}
dependency "security-groups" {
  config_path = "../security-groups"
}
# inject vars from env and dependent modules
inputs = merge(
  local.env.inputs,
  {
    vpc_id                = dependency.network.outputs.vpc_id
    public_subnet_ids     = dependency.network.outputs.public_subnet_ids
    alb_security_group_id = dependency.security-groups.outputs.alb_security_group_id
  }
)
