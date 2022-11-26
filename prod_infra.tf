variable "whitelist" {
  type = list(string)
}
variable "miaws_key" {
  type    = string
  default = "amazon_linux_key_1"
}

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
    cidr_blocks = var.whitelist
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

# module "web_app" {
#  source = "./modules/web_app"
#  miaws_instance_type = var.miaws_instance_type
#  miaws_key           = var.miaws_key
#  security_groups     = [aws_security_group.prod_web.id]
#  web_subnet          = aws_subnet.Public101.id
#  web_app             = "prod01"
#}
