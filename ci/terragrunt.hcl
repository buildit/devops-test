locals {
  env        = get_env("TF_VAR_ENV", "dev")
  aws_region = get_env("TF_VAR_AWS_REGION", "eu-west-2")
  s3_bucket  = get_env("TF_STATE_BUCKET", "devops-demo-test-terraform-bucket")
}

###
# DRY terraform backend
# Creates micro states
###
remote_state {
  backend = "s3"
  config = {
    encrypt = true
    bucket  = local.s3_bucket
    key     = "${local.env}/${local.aws_region}/${path_relative_to_include()}-terraform.tfstate"
    region  = local.aws_region
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

###
# DRY terraform backend
###
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
provider "aws" {
  region              = "${local.aws_region}"
  allowed_account_ids = ["523160825386"]
}
EOF
}