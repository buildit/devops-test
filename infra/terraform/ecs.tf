resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_iam_role" "ecs_iam_role" {
  name = "${var.cluster_name}-instance-role"

  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "ecs_policy" {
  role       = aws_iam_role.ecs_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.cluster_name}-instance-profile"
  role = aws_iam_role.ecs_iam_role.name
}

resource "aws_security_group" "instance_sg" {
  name        = "${var.cluster_name}-container-instance"
  description = "Security Group for container instance"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "egress_sg_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance_sg.id
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
  vars = {
    ecs_cluster                 = aws_ecs_cluster.ecs_cluster.name
  }
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

resource "aws_launch_configuration" "instance_lc" {
  name_prefix          = "${var.cluster_name}-lc"
  image_id             = data.aws_ami.ecs_ami.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  user_data            = data.template_file.user_data.rendered
  security_groups      = [aws_security_group.instance_sg.id]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "aws_asg" {
  name = "${var.cluster_name}-asg"
  launch_configuration = aws_launch_configuration.instance_lc.name
  vpc_zone_identifier  = module.vpc.private_subnets
  max_size             = "2"
  min_size             = "2"
  desired_capacity     = "2"
  health_check_grace_period = 300
  health_check_type         = "EC2"
  lifecycle {
    create_before_destroy = true
  }
}