resource "aws_security_group" "Jenkins-sg" {
  name        = "Jenkins-Security Group"
  description = "Open 22,443,80,8080"

  ingress = [
    for port in [22, 80, 443, 8080] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-sg"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0e001c9271cf7f3b9"
  instance_type          = "t2.medium"
  key_name               = "ansible-cotrol-key"
  vpc_security_group_ids = [aws_security_group.Jenkins-sg.id]
  user_data              = file("install_Ansible.sh")

  tags = {
    Name = "Jenkins-server"
  }

  root_block_device {
    volume_size = 8
  }

  provisioner "local-exec" {
    command = "chmod +x install_Ansible.sh"
  }
}
