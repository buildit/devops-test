# Local vars specific to this execution
locals {
  env = read_terragrunt_config("${get_parent_terragrunt_dir()}/env-config/env.hcl")
}

# Terraform source code location (can be a git repo too)
terraform {
    source = "${get_parent_terragrunt_dir()}/../infra/terraform/security-groups//"
}

include {
    path = find_in_parent_folders()
}

# Create dependency
dependency "network" {
  config_path = "../network"
}

# inject vars
inputs = merge (
  local.env.inputs,
  {
    vpc_id = dependency.network.outputs.vpc_id
  }
)