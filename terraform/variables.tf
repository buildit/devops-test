variable "gcp_project" {
  default = "vik-wipro"
}

variable "gcp_region" {
  default = "us-central1"
}

variable "vpc" {
  default = "default"
}

variable "instances" {
  default = 2
}

variable "machine_type" {
  default = "f1-micro"
}

variable "preemptible" {
  type = bool
  default = true
}

variable "disk_size_gb" {
  default = 10
}

variable "hostname_prefix" {
  default = "wipro-test"
}

variable "git_ref" {
  default = ""
}

variable "name" {
  description = "String used to make different versions of the stack unique"
  default = "main"
}
