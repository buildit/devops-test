resource "aws_key_pair" "public" {
  key_name   = "public"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOD1Q8Fc8QlJaDKnQBV6lZnYPSZcuz7YZsNK0FyTubTtMlOeoVuqWccEWGag6Q/zR85mUyanoxEHfGx4gH8Caxiev3J/RPqVYRtR8Q0RXLxdKO1Z9mAsOssDq2xzXvnd76uwUHASuUHuxiEGnOjL4sHJgrdPC23rV3CSr+JUS3zcpVvxslrvSjzMAeSFFedZN/oQ5UR/dscApfEkitIuwkKPSFwU6dBdVHN4tHebOMqLafGe1XJo1gyO798q+VhuMcAyxI5DOjSpwYNx+mHGOrJAEWpcVqTnIIcNYEGTII7394XbB8Q+CyQfuEF1qelUPvqWw0NEskJfiSqsRV7bJ1I5zb68f3gvS9TtRFZgZ2fs5zfIFnLq0WbLQnkExNKfycQF25M0+uFlkL5rE7YB25zVc6cRQU/ZPI7txmhyzijbuU3r+eII5CXAMhQelVzqPCEt7kO6AvEBz77jj4yYQwP6vp86Odyxs//1MNrIr5UdoX7V2G54Z/O/KeE/pL2zk="
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "buildit" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[count.index].id
  key_name               = aws_key_pair.public.key_name
  vpc_security_group_ids = [aws_security_group.allow_3000.id]
  user_data = "${templatefile("setup.sh", {
    version = "${var.app_version}"
    })
  }"
  tags = {
    Name = "WebServer-${count.index}"
  }
  count = length(var.availability_zones)
}