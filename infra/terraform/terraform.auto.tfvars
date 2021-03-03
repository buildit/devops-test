cluster_name   = "Demo"
instance_type  = "t2.micro"
container_port = 3000
container_cpu  = 1024
container_memory = 2048
desired_count = 2
container_name = "demo-task"
enable_alb = 1
region = "eu-west-2"
vpc_cidr = "10.0.0.0/24"
private_subnets      = ["10.0.0.0/28", "10.0.0.32/28"]
public_subnets       = ["10.0.0.192/28", "10.0.0.240/28"]
azs                  = ["eu-west-2a", "eu-west-2b"]