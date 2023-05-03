provider "aws" {
    access_key = ""
    secret_key = ""    
    region = "us-east-1"
}


resource "aws_instance" "ec2_instance" {
    ami = "ami-02396cdd13e9a1257"
    count = "1"
    subnet_id = "subnet-0db67d68399020659"
    instance_type = "t2.micro"
    key_name = "infra"
}
