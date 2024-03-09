terraform {
  required_version = ">=0.12"
}

resource "aws_instance" "ec2_example" {

  ami                    = "ami-09d8b83b58eabf58b"
  instance_type          = "t3.micro"
  key_name               = "default"
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data              = <<-EOF
            #!/bin/bash
            sudo su
            yum update -y
            yum install -y httpd
            cd /var/www/html
            wget https://github.com/azeezsalu/techmax/archive/refs/heads/main.zip
            unzip main.zip
            cp -r techmax-main/* /var/www/html/
            rm -rf techmax-main main.zip
            systemctl enable httpd 
            systemctl start httpd
      EOF
}

resource "aws_security_group" "main" {
  name        = "EC2-webserver-SG-1"
  description = "Webserver for EC2 Instances"

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


