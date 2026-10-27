# 020 — Terraform Intermediário (Variáveis, Outputs e Security Group)

## Objetivo
Refatorar o código do Lab 019 para aplicar boas práticas (separação de arquivos, variáveis e outputs) e provisionar a instância EC2 já com um Security Group gerenciado pelo Terraform.

## Arquivos

**`variables.tf`** (Parametrização)
**`main.tf`** (Recursos: Security Group + EC2)
**`outputs.tf`** (Exibição do IP Público)
**`.gitignore`** (Proteção do tfstate)

## Comandos

```bash
terraform init
terraform plan -var="nome_servidor=payfast-producao"
terraform apply -var="nome_servidor=payfast-producao" -auto-approve
terraform destroy -var="nome_servidor=payfast-producao" -auto-approve

## Aprendizado

Separação de arquivos: Em vez de um main.tf monolítico, dividir em variables.tf, main.tf e outputs.tf facilita a manutenção e leitura do código.

Variáveis (variables.tf): Permitem passar valores via linha de comando (-var="nome=valor"), evitando alterar o código-fonte para cada ambiente (dev, prod, etc).

Outputs (outputs.tf): Exibem informações úteis após o apply (como o IP da máquina) para facilitar integrações e scripts futuros.

Dependência Implícita: Ao usar vpc_security_group_ids = [aws_security_group.payfast_sg.id], o Terraform entende que o Security Group precisa ser criado antes da máquina. O .id recupera o ID dinâmico gerado pela AWS.

Segurança: A porta SSH (22) não deve ser aberta para 0.0.0.0/0 (mundo), mas sim para IPs confiáveis (VPN, IP da empresa).

## Dificuldades

Entender como o Terraform liga o Security Group à instância usando a referência de ID.
