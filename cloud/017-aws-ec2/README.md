# 017 — Primeira VM na AWS (EC2)

## Objetivo
Provisionar uma instância EC2 na AWS, configurar acesso SSH via chave e instalar um servidor web Nginx acessível publicamente.

## Passos executados

1. **Criação da Conta e IAM:** Conta AWS criada, usuário IAM configurado com MFA por segurança.
2. **Criação da Instância:** Ubuntu Server (Free Tier), tipo t2.micro. Par de chaves (.pem) gerado.
3. **Security Group:** Liberadas portas 22 (SSH) e 80 (HTTP).
4. **Acesso SSH:**
   ```bash
   chmod 400 ~/.ssh/payfast-keys.pem
   ssh -i ~/.ssh/payfast-keys.pem ubuntu@<IP_PUBLICO>


Instalação do Nginx:

bash
sudo apt update && sudo apt upgrade -y
sudo apt install nginx -y
sudo systemctl status nginx


Aprendizado

Chaves SSH: O arquivo .pem precisa de permissão 400 (somente leitura pelo dono), senão o SSH recusa a conexão por segurança.

Security Groups: Funcionam como um firewall na nuvem. Sem liberar a porta 80, o Nginx rodaria na VM, mas não seria acessível pela internet.

systemd na nuvem: O systemctl funciona exatamente igual no servidor local e no servidor na AWS.

Custos: É essencial parar (Stop) a instância quando não estiver usando para evitar cobranças.

Dificuldades

Erro de permissão UNPROTECTED PRIVATE KEY FILE! ao tentar conectar via SSH por esquecer o chmod 400.

Confusão inicial com o arquivo .pem (era uma pasta em vez do arquivo de chave).

