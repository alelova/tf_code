variable "default_instance_type" {
  type    = string
  default = "t2.nano"
}
variable "default_web_subnet"{
  type = string
  default = "aws_subnet.Public101.id"
}


resource "aws_instance" "ale-0001" {
  ami                            = "ami-06863551a8f6d6b1f"
  instance_type                  = var.default_instance_type
  key_name                       = var.miaws_key
  vpc_security_group_ids         = [aws_security_group.prod_web.id]
  subnet_id                      = aws_subnet.Public101.id
  associate_public_ip_address    = "true"

  tags = { 
    Name = "ale-0001"
    "Terraform" = "true"
  }
}

