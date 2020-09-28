variable "availability_zones" {
  type = list
  default = ["eu-west-1a", "eu-west-1b"]
}
variable "subnets" {
    type = list
    default = ["10.0.0.0/24", "10.0.1.0/24"]
}
variable "app_version" {}