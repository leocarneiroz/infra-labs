terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "payfast_web" {
  ami           = "ami-04b70fa74e45c3917" # Ubuntu 22.04 LTS em us-east-1
  instance_type = "t2.micro"

  tags = {
    Name = "payfast-web-tf"
  }
}
