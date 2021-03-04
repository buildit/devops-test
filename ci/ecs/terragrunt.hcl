# Local vars specific to this execution
locals {
  env = read_terragrunt_config("${get_parent_terragrunt_dir()}/env-config/env.hcl")
}

# Terraform source code location (can be a git repo too)
terraform {
  source = "${get_parent_terragrunt_dir()}/../infra/terraform/ecs//"
}

# Include config from parent folder
include {
  path = find_in_parent_folders()
}

# Create dependency
dependency "network" {
  config_path = "../network"
}
dependency "ecr" {
  config_path = "../ecr"
}
dependency "security-groups" {
  config_path = "../security-groups"
}
dependency "alb" {
  config_path = "../alb"
}
# inject vars from env and dependent modules
inputs = merge(
  local.env.inputs,
  {
    private_subnet_ids = dependency.network.outputs.private_subnet_ids
    ecr_repository_url = dependency.ecr.outputs.ecr_repository_url
    ecs_sg_id          = dependency.security-groups.outputs.ecs_sg_id
    target_group_arn   = dependency.alb.outputs.target_group_arn
  }
)
