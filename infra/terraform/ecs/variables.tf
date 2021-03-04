variable "region" {}
variable "container_cpu" {}
variable "container_memory" {}
variable "container_port" {}
variable "cluster_name" {}
variable "ecs_task_family" {}
variable "desired_count" {}
# ecr_repository_url is injected from ecr repo
variable "ecr_repository_url" {}
variable "container_name" {}
# dependency injected from network module
variable "private_subnet_ids" {
    type = list
}
# dependency injected from security-groups module
variable "ecs_sg_id" {}
# dependency injected by alb module
variable "target_group_arn" {}