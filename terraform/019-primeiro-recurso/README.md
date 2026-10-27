# 019 — Primeiro Recurso na AWS com Terraform

## Objetivo
Provisionar uma instância EC2 na AWS utilizando Infraestrutura como Código (IaC) com Terraform, aplicando o ciclo de vida (init, plan, apply, destroy) e gerenciando o estado de forma segura.

## Arquivos

**`main.tf`**
```hcl
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
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"

  tags = {
    Name = "payfast-web-tf"
  }
}
.gitignore

text
*.tfstate
*.tfstate.backup
.terraform/
*.pem

## Comandos

bash
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve

## Aprendizado

terraform init: Inicializa o diretório de trabalho e baixa os plugins do provider (AWS).

terraform plan: Simula a execução e mostra o que será criado, alterado ou destruído. Essencial para evitar surpresas financeiras.

terraform apply: Executa as mudanças de fato na nuvem.

terraform destroy: Remove todos os recursos declarados no código.

terraform.tfstate: Arquivo crítico que mapeia os recursos reais da AWS com o código. Se for perdido, o Terraform perde a referência. Deve ser colocado no .gitignore e, em produção, armazenado em backend remoto (como S3) com trava (lock).

Credenciais: O Terraform usa as credenciais configuradas localmente via aws configure (~/.aws/credentials), mantendo o código seguro sem senhas hardcoded.

## Dificuldades

Criação de Usuário IAM e Access Keys, compreendendo a importância de nunca expor credenciais (vazamento de chaves).
