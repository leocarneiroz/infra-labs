# 006 — Docker Compose (API + Postgres)

## Objetivo
Subir API e banco juntos com um único `docker compose up`.

## Arquivo

```yaml
services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: payfast
      POSTGRES_PASSWORD: payfast123
      POSTGRES_DB: payfastdb
    ports:
      - "5432:5432"

  api:
    build: ../005-dockerfile-payfast
    ports:
      - "8082:8000"
    depends_on:
      - db
```

## Comando
```bash
docker compose up -d
docker compose ps
```

## Aprendizado
- `image` usa imagem pronta do registry. `build` constrói a partir de um Dockerfile local.
- Compose cria uma rede default e cada serviço ganha um DNS interno com o nome do serviço. Por isso a API acessa o banco via `db:5432`, não `localhost` — `localhost` dentro do container aponta pro próprio container.
- Porta do host é recurso exclusivo — só um processo por vez.
- `docker compose up -d` é idempotente: se o container já existe, ele não recria. Use `down && up` quando algo deu errado.

## Dificuldades
- Conflito de porta 8082 com o container do lab 005 (`port is already allocated`). Resolvido parando o container antigo.
- Container do `api` ficou em estado inconsistente (Up mas sem porta publicada) após falha parcial. Resolvido com `docker compose down && docker compose up -d`.
