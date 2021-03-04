# Local vars specific to this execution
locals {
  env = read_terragrunt_config("${get_parent_terragrunt_dir()}/env-config/env.hcl")
}

# Terraform source code location (can be a git repo too)
terraform {
  source = "${get_parent_terragrunt_dir()}/../infra/terraform/ecr//"
}

# Include config from parent folder
include {
  path = find_in_parent_folders()
}

# inject vars from env and dependent modules
inputs = local.env.inputs