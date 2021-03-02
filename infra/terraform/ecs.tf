resource "aws_ecs_cluster" "ecs" {
  name = "demo-ecs"
  tags               = {
    Environment = "demo"
    Owner = "Ravindra"
    ManagedBy = "Terraform"
    Destroy = true
  }  
}

resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "demo-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn
  container_definitions = jsonencode([{
    name        = "demo-container"
    image       = "demo-ecr:latest"
    essential   = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
  }])
  tags               = {
    Environment = "demo"
    Owner = "Ravindra"
    ManagedBy = "Terraform"
    Destroy = true
  } 
}

resource "aws_ecs_service" "ecs_service" {
  name                               = "demo-service"
  cluster                            = aws_ecs_cluster.ecs.id
  task_definition                    = aws_ecs_task_definition.ecs_task_def.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 100
  health_check_grace_period_seconds  = 30
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = [module.vpc.private_subnets]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-2a]"
  }  
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}