resource "aws_lb" "public_alb" {
  name               = "demo-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false
  tags = {
    Name        = "demo-public-alb"
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name        = "demo-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    protocol            = "HTTP"
    path                = "/"
  }
}

# Forward traffic to target group
resource "aws_alb_listener" "http" {
    load_balancer_arn = aws_lb.public_alb.id
    port              = 80
    protocol          = "HTTP"
    default_action {
        target_group_arn = aws_alb_target_group.alb_target_group.id
        type             = "forward"
    }
}