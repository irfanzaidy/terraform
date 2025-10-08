#kay pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
public_key = file(("irfan-key.pub"))
}


# using default VPC 

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
#security grup

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
   description = "open ssh"
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http open"
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "allow_ssh"
  }
}


# ec2 instance
resource "aws_instance" "my-instance" {
 key_name = aws_key_pair.deployer.key_name
 security_groups = [aws_security_group.allow_ssh.name ]
 ami       = "ami-02d26659fd82cf299"
 user_data = file("/home/irfan/terraform/terraform-ec2/script.sh")

 instance_type = "t3.micro"
 tags = {
    Name = "terra-server-nginx"
  }
  root_block_device {
    volume_size =  8
    volume_type = "gp3"
  }
}
