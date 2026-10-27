terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.regiao
}

# Aqui criamos o Security Group (Firewall)
resource "aws_security_group" "payfast_sg" {
  name        = "payfast-sg-terraform"
  description = "Permite SSH e HTTP"

  # Porta 22 (SSH) - Apenas do seu IP para segurança
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Em produção, troque pelo seu IP
  }

  # Porta 80 (HTTP) - Aberta pro mundo
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "payfast_web" {
  ami                    = "ami-04b70fa74e45c3917"
  instance_type          = var.tipo_instancia
  vpc_security_group_ids = [aws_security_group.payfast_sg.id] # <-- Aqui ligamos o firewall à máquina

  tags = {
    Name = var.nome_servidor
  }
}
