resource "aws_instance" "this" {
  ami                            = "ami-0245697ee3e07e755"
  instance_type                  = var.miaws_instance_type
  key_name                       = var.miaws_key
  vpc_security_group_ids         = var.security_groups
  subnet_id                      = var.web_subnet
  associate_public_ip_address    = "true"

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
    inline = [
      "sudo hostnamectl set-hostname prodweb",
      "echo '127.0.0.1 prodweb' | sudo tee -a /etc/hosts",
      "echo '172.31.1.33 puppet' | sudo tee -a /etc/hosts",
      "wget https://apt.puppet.com/puppet7-release-buster.deb",
      "sudo dpkg -i puppet7-release-buster.deb",
      "sudo apt-get update",
      "sudo apt-get install puppet-agent",
      "sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true",
    ]
  }
}

