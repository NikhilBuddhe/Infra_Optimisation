provider "aws" {

    access_key = ""

    secret_key = ""    

    region = "us-east-1"

}





resource "aws_instance" "ec2_instance" {

    ami = "ami-02396cdd13e9a1257"

    count = "1"

    subnet_id = aws_subnet.example1.id

    instance_type = "t2.micro"

    key_name = "infra"

} 



resource "aws_vpc" "default" {

    cidr_block = "10.0.0.0/24"

 

  tags = {

    Name = "Default VPC"

  }

}

resource "aws_internet_gateway" "gw" {

  vpc_id = aws_vpc.default.id



  tags = {

    Name = "gw"

  }

}

resource "aws_subnet" "example1" {

  vpc_id     = aws_vpc.default.id

  cidr_block = "10.0.0.0/25"
  availability_zone = "us-east-1a"
  tags = {

    Name = "example1"

  }

}



resource "aws_subnet" "example2" {



  vpc_id     = aws_vpc.default.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.0.128/25"

  tags = {

    Name = "example2"

  }

}



resource "aws_security_group" "lb_sg" {



  name        = "allow_tls"

  description = "Allow all inbound traffic"

  vpc_id      = aws_vpc.default.id



  ingress {



    description      = "TLS from VPC"

    from_port        = 0

    to_port          = 0

    protocol         = "-1"

    cidr_blocks      = ["0.0.0.0/0"]

    ipv6_cidr_blocks = ["::/0"]

  }



  egress {



    from_port        = 0

    to_port          = 0

    protocol         = "-1"

    cidr_blocks      = ["0.0.0.0/0"]

    ipv6_cidr_blocks = ["::/0"]



  }



  tags = {

    Name = "lb_sg"

  }

}







resource "aws_lb" "lb_ec2" {

  name               = "lb-in-ec2"

  load_balancer_type = "network"



  subnet_mapping {

    subnet_id     = aws_subnet.example1.id

  }



  subnet_mapping {

    subnet_id     = aws_subnet.example2.id

  }

}
