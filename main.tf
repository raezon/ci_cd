provider "aws" {
  region     = var.region
  access_key = "AKIAUCSQQOVVGULITLEI"
  secret_key = "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"
}

# creation of vpc
resource "aws_vpc" "production_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "Production VPC"
  }
}
# creation of internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.production_vpc.id
}
# creation of elastic ip addresse
resource "aws_eip" "nat-eip" {
  depends_on = [aws_internet_gateway.igw]
}
# creation of nat gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.private_subnet_1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
# creation public route table
# what does that mean  for what ever ipv4 address in that network route it's nat gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block = var.all_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public route table"
  }

}

#creation private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block     = var.all_cidr
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private route table"
  }

}
# creation public subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.production_vpc.id
  cidr_block              = var.public_subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "public subnet"
  }
}
# creation public subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.production_vpc.id
  cidr_block              = var.public_subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone2
  tags = {
    Name = "Public subnet 2"
  }
}
# creation private subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.availability_zone2
  tags = {
    Name = "Private subnet 1"
  }
}

# associate public route table with public subnet 1 
resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}
# associate public route table with public subnet 2 
resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}
# associate public route table with private subnet 1 
resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}
# create security groupe jenkins
resource "aws_security_group" "jenkins-sg" {
  name        = "Jenkins SG"
  description = "Allow Port 8080 and 22"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    description = "Jenkins"
    from_port   = var.jenkins_port
    to_port     = var.jenkins_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
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
    Name = "Jenkins SG"
  }

}
# create security group sonar qube
resource "aws_security_group" "sonarqube-sg" {
  name        = "Sonarqube SG"
  description = "Allow Port 9000 and 22"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    description = "Sonarqube"
    from_port   = var.sonarqube_port
    to_port     = var.sonarqube_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
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
    Name = "Sonarqube SG"
  }

}
# create security group ansible
resource "aws_security_group" "ansible-sg" {
  name        = "Anisble SG"
  description = "Allow Port  22"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    description = "ssh"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
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
    Name = "Ansible SG"
  }

}
# create security group grafana
resource "aws_security_group" "grafana-sg" {
  name        = "Grafana SG"
  description = "Allow Port 3000 and  22"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    description = "Grafana"
    from_port   = var.grafana_port
    to_port     = var.grafana_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
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
    Name = "Grafana SG"
  }

}
# create security group load balancer
resource "aws_security_group" "load-balancer-sg" {
  name        = "LoadBalancer SG"
  description = "Allow Port 80"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    description = "LoadBalancer"
    from_port   = var.http_port
    to_port     = var.http_port
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
    Name = "Load balancer SG"
  }

}

# Create application security group
resource "aws_security_group" "app_sg"{
  name = "Application SG"
  description = "Allow ports 80, 443 and 22"
  vpc_id = aws_vpc.production_vpc.id

  ingress {
    description = "HTTP"
    from_port = var.http_port
    to_port = var.http_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port = var.https_port
    to_port = var.https_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port = var.ssh_port
    to_port = var.ssh_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Application SG"
  }
}

# create network acl jenkins
/*resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.production_vpc.id
  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
    aws_subnet.private_subnet_1.id
  ]

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.all_cidr
    from_port  = var.http_port
    to_port    = var.http_port
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = var.all_cidr
    from_port  = var.ssh_port
    to_port    = var.ssh_port
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = var.all_cidr
    from_port  = var.jenkins_port
    to_port    = var.jenkins_port
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 103
    action     = "allow"
    cidr_block = var.all_cidr
    from_port  = var.sonarqube_port
    to_port    = var.sonarqube_port
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 104
    action     = "allow"
    cidr_block = var.all_cidr
    from_port  = var.grafana_port
    to_port    = var.grafana_port
  }

  tags = {
    Name = "Main acl"
  }
}*/

# create ecr
resource "aws_ecr_repository" "ecr_repo" {
  name = "docker_repository"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# create key pair
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.key_secret
}

# create s3 bucket
/*resource "aws_s3_bucket" "s3_bucket" {
  bucket = "s3-bucket-reazon-xithal-2754"
  acl ="private"
  versioning {
   # enabled = true
  }
  tags = {
    Name        = "Terraform state bucket"
  }
}*/

# configure the s3 backend
terraform{
  backend "s3"{
    bucket="s3-bucket-reazon-xithal-2754"
    key= "prod/terraform.tfstate"
    region="eu-central-1"
    access_key = "AKIAUCSQQOVVGULITLEI"
    secret_key = "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"
  }
}

# create jenkins instance
resource "aws_instance" "jenkins" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  availability_zone=var.availability_zone
  subnet_id =aws_subnet.public_subnet_1.id
  key_name=var.key_name
  vpc_security_group_ids =[aws_security_group.jenkins-sg.id]
  user_data = file("jenkins_install.sh")

  tags = {
    Name        = "jenkins-instance"
  }

}

/*
# create ansible instance
resource "aws_instance" "ansible" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  availability_zone=var.availability_zone
  subnet_id =aws_subnet.public_subnet_1.id
  key_name=var.key_name
  vpc_security_group_ids =[aws_security_group.jenkins-sg.id]
  user_data = file("ansible_install.sh")

  tags = {
    Name        = "Ansible"
  }

}

# Create the launch configuration for application hosts 
resource "aws_launch_configuration" "app-launch-config" {
  name = "app-launch-config"
  image_id      = var.instance_ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.app_sg.id]
  key_name = var.key_name
  user_data = file("autoscaling_install.sh")
}

# Create the app autoscaling group
resource "aws_autoscaling_group" "app-asg" {
  name                      = "app-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_type         = "EC2" 
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.app-launch-config.name
  vpc_zone_identifier       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  target_group_arns         = [aws_lb_target_group.app-target-group.arn]
}

# Create the app target group
resource "aws_lb_target_group" "app-target-group" {
  name     = "app-target-group"
  port     = 80
  target_type = "instance"
  protocol = "HTTP"
  vpc_id   = aws_vpc.production_vpc.id
}

# Attach the ASG to the target group
resource "aws_autoscaling_attachment" "autoscaling-attachment" {
  autoscaling_group_name = aws_autoscaling_group.app-asg.id
  lb_target_group_arn   = aws_lb_target_group.app-target-group.arn
}

# Create the application Load Balancer
resource "aws_lb" "app-lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

# Create the listener for the Load Balancer
resource "aws_lb_listener" "app-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-target-group.arn
  }
}
*/