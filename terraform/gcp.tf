provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

terraform {
  backend "gcs" {
    bucket = "vik-wipro-terraform-state"
    prefix = "devops-test"
  }
}
