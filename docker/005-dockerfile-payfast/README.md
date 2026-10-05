# 005 — Dockerfile customizado (payfast-api)

## Objetivo
Buildar imagem própria a partir de Dockerfile com app Python.

## Dockerfile
```dockerfile
FROM python:3.11-alpine
WORKDIR /app
COPY . .
EXPOSE 8000
CMD ["python", "app.py"]
```

## Comando
```bash
docker build -t payfast-api:v1 .
docker run -d --name payfast-api -p 8082:8000 payfast-api:v1
```

## Aprendizado
- `Dockerfile` = receita. `docker build` = executa. Imagem = snapshot. Container = processo rodando.
- Cada instrução do Dockerfile = **uma layer**. Layers em cache aceleram rebuild.
- Ordem importa: instruções que mudam com frequência vão por último.
- `EXPOSE` é **documentação**, não abre porta. Quem publica é o `-p` do `run`.
- `-t nome:tag` versiona a imagem. Sem tag, vira `:latest`.

## Erro/observação
Primeiro Dockerfile tinha `COPY . ~/labs/app-payfast/` (path do host como destino) e `EXPOSE 8082` (porta errada — app escuta na 8000). Ambos corrigidos.
