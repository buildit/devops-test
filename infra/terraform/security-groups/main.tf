###
# ALB SG
###
resource "aws_security_group" "alb_sg" {
  name        = "public-alb-sg"
  vpc_id      = var.vpc_id
  description = "Public ALB Security Group"
  tags = {
    Environment = "demo"
    Owner       = "Ravindra"
    ManagedBy   = "Terraform"
    Destroy     = true
  }
}
resource "aws_security_group_rule" "alb_sg_ingress" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "alb_sg_egress" {
  security_group_id        = aws_security_group.alb_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = var.container_port
  to_port                  = var.container_port
  source_security_group_id = aws_security_group.ecs_sg.id
}

###
# ECS SG
###
resource "aws_security_group" "ecs_sg" {
  name   = "ecs-instance-sg"
  vpc_id = var.vpc_id
  tags = {
    Environment = "demo"
    Owner       = "Ravindra"
    ManagedBy   = "Terraform"
    Destroy     = true
  }
}
resource "aws_security_group_rule" "ecs_sg_ingress" {
  security_group_id = aws_security_group.ecs_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.container_port
  to_port           = var.container_port
  source_security_group_id = aws_security_group.alb_sg.id
}
resource "aws_security_group_rule" "ecs_sg_egress" {
  security_group_id = aws_security_group.ecs_sg.id
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

