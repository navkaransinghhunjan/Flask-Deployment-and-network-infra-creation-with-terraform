# Provider configuration
provider "aws" {
  region = "ap-south-1" # Replace with your desired AWS region
}

# Variables
variable "cidr" {
  default = "10.0.0.0/16"
}

# Key Pair
resource "aws_key_pair" "key-pair" {
  key_name   = "my_laptop_ssh" # Replace with your desired key name
  public_key = file("~/.ssh/id_ed25519.pub") # Replace with the path to your public key
}

# VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

# Subnet
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.cidr
  availability_zone       = "ap-south-1a" # Replace with your desired AZ
  map_public_ip_on_launch = true
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

# Route Table
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

# Security Group
resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "Web-sg"
  }
}

# EC2 Instance
resource "aws_instance" "server" {
  ami                    = "ami-00bb6a80f01f03502" # Replace with a suitable Ubuntu AMI
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key-pair.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id

  tags = {
    NAME = "flask-app-instance"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu" # Replace with your EC2 instance username
    private_key = file("~/.ssh/id_ed25519") # Replace with the path to your private key
    host        = self.public_ip
  }

  # File provisioner to copy Flask app to the instance
  provisioner "file" {
    source      = "app.py" # Replace with the path to your Flask app
    destination = "/home/ubuntu/app.py"
  }

  # Remote-exec provisioner to install dependencies and start Flask app
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt-get install -y python3-venv",
      "python3 -m venv /home/ubuntu/venv",
      "/home/ubuntu/venv/bin/pip install flask",
      "/home/ubuntu/venv/bin/python /home/ubuntu/app.py &"
    ]
  }
}
