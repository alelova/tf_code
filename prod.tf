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
    Name = "Public101 Subnet"
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


