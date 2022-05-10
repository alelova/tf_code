provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-course-ln-20220318"
}
resource "aws_default_vpc" "default" {}

resource "aws_subnet" "Public101" {
  vpc_id     = aws_default_vpc.default.id
  cidr_block = "172.31.101.0/24"

  tags = {
    Name = "Public101"
    "Terraform" = "true"
  }
}
resource "aws_security_group" "prod_web"{
  name = "prod_web"
  description = " allows standard http y https ports inbound"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    ="-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = { 
  "Terraform" = "true"
  }
}

resource "aws_instance" "prod_web" {
  ami           = "ami-0245697ee3e07e755"
  instance_type = "t2.nano"
  key_name      = "amazon_linux_key_1"

  subnet_id                      = aws_subnet.Public101.id
  associate_public_ip_address    = "true"
  vpc_security_group_ids         = [aws_security_group.prod_web.id]

  tags = { 
    Name = "prod_web"
    "Terraform" = "true"
  }
  connection {
    type        = "ssh"
    user        = "admin"
    private_key = "${file("~/Documents/ale/aws/key/amazon_linux_key_1.pem")}"
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname prodweb"]
  }

}

