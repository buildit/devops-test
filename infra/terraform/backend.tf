terraform {
  backend "s3" {
      bucket        = "devops-demo-test-terraform-bucket"
      region        = "eu-west-2"
      key           = "dev/hello"
  }
}