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