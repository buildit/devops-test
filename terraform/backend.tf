provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "buildittest"
    key    = "webserver.tfstate"
    region = "eu-west-1"
  }
}
