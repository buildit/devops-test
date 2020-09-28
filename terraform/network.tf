# Create a VPC
resource "aws_vpc" "buildit" {
  cidr_block = "10.0.0.0/21"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.buildit.id
  cidr_block = var.subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "public"
  }
  count = length(var.subnets)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.buildit.id
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.buildit.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group" "allow_3000" {
  name        = "allow_3000"
  description = "Allow 3000 inbound traffic"
  vpc_id      = aws_vpc.buildit.id

  ingress {
    description = "npm ingress"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_3000"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.buildit.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
  count = length(var.subnets)
}
