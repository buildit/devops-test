variable "container_port" {}
# dependency injected from network module
variable "public_subnet_ids" {
  type = list
}
variable "vpc_id" {}
# dependency injected from security-groups module
variable "alb_security_group_id" {}