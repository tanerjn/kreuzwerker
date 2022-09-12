#
#
# 09/2022, used Terraform v4.30, developed on MacOS Catalina
# Configuration files to deploy 1 non-default VPC with 6 Subnet and a EC2 instance
# Inctance is responsible of running docker image which hosts a staic website. 
# 2 application layer private subnet, 2 data layer private subnet, 2 public subnet in 2 AZs.
#

#Creation of the VPC
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr 
  instance_tenancy        = "default"
  enable_dns_hostnames    = true
  enable_dns_support      = true
  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

#Default IGW
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id
  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

#Route Public
resource "aws_route_table" "public_route" {
	vpc_id = aws_vpc.vpc.id
	# Routing IGW
	route { 
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.internet_gateway.id
	}
	tags = {
		Name = "public route"
	}
}

data "aws_availability_zones" "available_zones" {}

#Creation of subnet
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone 	    = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true
  tags      = {
    Name    = "public subnet az1"
  }
}
#Creation of subnet
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true
  tags      = {
    Name    = "public subnet az2"
  }
}

# Associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az1.id
  route_table_id      = aws_route_table.public_route.id
}

# Associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az2.id
  route_table_id      = aws_route_table.public_route.id
}

# Create subnet for App Instance
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_app_subnet_az1_cidr
  availability_zone 	     = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false
  tags      = {
    Name    = "private app subnet az1"
  }
}

# Create subnet for Data Instance
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_data_subnet_az1_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false
  tags      = {
    Name    = "private data subnet az1"
  }
}

# Create subnet for App Instance
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_app_subnet_az2_cidr
  availability_zone 	     = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false
  tags      = {
    Name    = "private app subnet az1"
  }
}

# Create subnet for Data Instance
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_data_subnet_az2_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false
  tags      = {
    Name    = "private data subnet az1"
  }
}

# Aamazon linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_security_group" "security_group" {

  name        = "security group web"
  description = "Allow access on ports 80 and 443"
  vpc_id      = aws_vpc.vpc.id
  
  ingress {
    description = "tcp access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  
  ingress {
    description = "all icmp"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "tcp access"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kreuzwerker security group"
  }
}

output "aws_security_group_id" {
  value = "${aws_security_group.security_group.id}"
}

#Elastic IP Address for NAT 
resource "aws_eip" "nat_eip" {
  instance = aws_instance.ec2_instance.id
  vpc = true
}

#NAT GW 
resource "aws_nat_gateway" "nat_gw"{
	#Allocation iD of the Elastic IP address for the gateway.
	allocation_id = aws_eip.nat_eip.id
	#Subnet ID of the subnet which will connect the gateway.
	subnet_id = aws_subnet.public_subnet_az1.id
	tags = {
		Name = "nat gw"
	}
}

#Route Private 1
resource "aws_route_table" "private_route" {
	vpc_id = aws_vpc.vpc.id
	# Routing Provate NAT 1
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_nat_gateway.nat_gw.id
	}
	tags = {
		Name = "private route"
	}
}

#Association public subnet 1 
resource "aws_route_table_association" "public_route_association" {
	#The Subnet ID Public 1
	subnet_id = aws_subnet.public_subnet_az1.id
	#The ID Public Route
	route_table_id =  aws_route_table.public_route.id
}

#Association private subnet 1 
resource "aws_route_table_association" "private_route_association" {
	#The Subnet ID Private 1
	subnet_id = aws_subnet.private_app_subnet_az1.id
	#ID of Private 1
	route_table_id =  aws_route_table.private_route.id
}


# Launch the EC2 instance in Public Subnet-1
resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.amazon_linux_2.id 
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_az1.id
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  key_name                    = "test-kreuzwerker" 
  user_data              = <<-EOF
                        #!/bin/bash
                        apt-get update
                        apt-get install -y apache2
                        echo "Hello World" > /var/www/html/index.html
                        systemctl restart apache2
                        EOF
  tags = {
    Name = "kreuzwerker-worker-1"
  }
}

# File transfers
resource "null_resource" "name" {

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/Downloads/secrets/test-kreuzwerker.pem")
    host        = aws_instance.ec2_instance.public_ip
  }

  provisioner "file" {
    source      = "~/Downloads/secrets/dockerpass.txt"
    destination = "/home/ec2-user/dockerpass.txt"
  }

  provisioner "file" {
    source      = "../Dockerfile"
    destination = "/home/ec2-user/Dockerfile"
  }

  provisioner "file" {
    source      = "../build_docker_image.sh"
    destination = "/home/ec2-user/build_docker_image.sh"
  }
  
  provisioner "file" {
    source      = "static/index.html"
    destination = "/home/ec2-user/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ec2-user/build_docker_image.sh",
      "sh /home/ec2-user/build_docker_image.sh",
    ]
  }
	depends_on = [ aws_instance.ec2_instance ]
}

output "website_url_dns" {
  value = join("", ["http://", aws_instance.ec2_instance.public_dns, ":", "8000"])
}







