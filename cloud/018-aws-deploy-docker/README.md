# 018 — Deploy de Aplicação Docker na AWS EC2

## Objetivo
Provisionar uma instância EC2, instalar o Docker e realizar o deploy da aplicação `payfast-api` via container, configurando o acesso externo com Security Group específico.

## Passos executados

1. **Instalação do Docker na VM:**

   ```bash
   sudo apt update
   sudo apt install ca-certificates curl
   sudo install -m 0755 -d /etc/apt/keyrings
   sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
   sudo chmod a+r /etc/apt/keyrings/docker.asc
   # Adição do repositório oficial e instalação dos pacotes
   sudo apt install docker-ce docker-ce-cli containerd.io -y

2. **Clonagem do repositório e Build da imagem:**

bash
git clone https://github.com/leocarneiroz/infra-labs.git
cd infra-labs/docker/005-dockerfile-payfast/
sudo docker build -t payfast-api:v1 .

3. **Execução do container:**

bash
sudo docker run -d --name payfast-api -p 8082:8000 payfast-api:v1

4. **Configuração do Security Group (Firewall da AWS):**

Criado um Security Group específico chamado payfast-api Acess.

Regra de entrada (Inbound Rule) adicionada:

Protocolo: TCP

Porta: 8082

Origem: 0.0.0.0/0 (Anywhere-IPv4)

5. **Resultado**

Acesso via navegador no IP público da instância na porta 8082 retornou PayFast API - OK.

6. **Aprendizado**

Docker em cloud: O Docker funciona exatamente igual na AWS e no WSL local. A instalação exige adicionar o repositório oficial da Docker.

Security Groups nomeados: Criar Security Groups específicos por aplicação (em vez de editar o grupo padrão launch-wizard) é a melhor prática de segurança (Princípio do Menor Privilégio) e organização em ambientes cloud.

Firewall em camadas: O container estava rodando e exposto na porta 8082 na VM, mas sem a regra no Security Group, o tráfego era bloqueado na borda da AWS.

