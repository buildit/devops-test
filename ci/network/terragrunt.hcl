locals {
  env = read_terragrunt_config("${get_parent_terragrunt_dir()}/env-config/env.hcl")
}

terraform {
    source = "${get_parent_terragrunt_dir()}/../infra/terraform/network//"
}

include {
    path = find_in_parent_folders()
}

inputs = local.env.inputs