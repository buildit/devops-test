resource "aws_elb" "webserver" {
  name            = "webserver-elb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.allow_http.id]

  listener {
    instance_port     = 3000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:3000/"
    interval            = 30
  }


  instances                   = aws_instance.buildit.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

}

output "load_balancer_address" {
  value = aws_elb.webserver.dns_name
}