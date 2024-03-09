terraform {
  required_version = ">=0.12"
}
resource "aws_instance" "ec2_example" {
  ami                    = "ami-09d8b83b58eabf58b"
  instance_type          = "t3.micro"
  key_name               = ""
  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = <<-EOF
      #!/bin/bash
      sudo su
      yum update -y
      amazon-linux-extras install nginx1 -y
      systemctl enable nginx
      systemctl start nginx
      systemctl status nginx 
      sudo echo <!DOCTYPE html> <html> <head> <meta name="viewport" content="width=device-width, initial-scale=1"> <title>youtube Allow Fullscreen</title> </head> <body> <!--Need Internet Connection--> <!--Fullscreen allow--> <iframe width="420" height="315" src="https://www.vcube.com/embed/OK7fy40Ai6A" allowfullscreen></iframe> </body> </html>" > /usr/share/nginx/html/index.html
      systemctl restart nginx 
      EOF
}

resource "aws_security_group" "main" {
  name        = "EC2-webserver-SG-2"
  description = "Webserver for EC2 Instances"

  ingress {
    from_port   = 8080
    protocol    = "TCP"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
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


