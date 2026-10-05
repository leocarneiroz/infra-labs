# Define a imagem base
FROM python:3.11-alpine

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos do projeto para o contêiner
COPY . .

# Expõe a porta que a aplicação vai usar
EXPOSE 8000

# Define o comando padrão para iniciar o aplicativo
CMD ["python", "app.py"]
