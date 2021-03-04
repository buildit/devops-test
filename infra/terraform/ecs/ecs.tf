resource "aws_ecs_cluster" "ecs" {
  name = var.cluster_name
  tags = {
    Environment = "demo"
    Owner       = "Ravindra"
    ManagedBy   = "Terraform"
    Destroy     = true
  }
}

resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = var.ecs_task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn
  container_definitions = jsonencode([{
    name      = var.container_name
    image     = var.ecr_repository_url
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = tonumber(var.container_port)
      hostPort      = tonumber(var.container_port)
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_logs_group.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])
  tags = {
    Environment = "demo"
    Owner       = "Ravindra"
    ManagedBy   = "Terraform"
    Destroy     = true
  }
}

resource "aws_ecs_service" "ecs_service" {
  name                               = "demo-service"
  cluster                            = aws_ecs_cluster.ecs.id
  task_definition                    = aws_ecs_task_definition.ecs_task_def.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
  launch_type                        = "FARGATE"
  platform_version                   = "1.4.0"
  scheduling_strategy                = "REPLICA"
  network_configuration {
    security_groups  = [var.ecs_sg_id]
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_cloudwatch_log_group" "ecs_logs_group" {
  name = "/ecs/${var.container_name}"
}
