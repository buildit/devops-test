variable "region" {}
variable "vpc_cidr" {}
variable "private_subnets" {
    type = list
}
variable "public_subnets" {
    type = list
}
variable "azs" {
    type = list
}