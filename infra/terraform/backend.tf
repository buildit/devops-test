terraform {
  backend "remote" {
    organization = "Ravi-demo"

    workspaces {
      name = "demo"
    }
  }
}