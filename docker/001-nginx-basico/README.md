# 001 — Nginx básico em container

## Objetivo
Subir container Nginx acessível em http://localhost:8080.

## Comando
```bash
docker run -d --name nginx-teste -p 8080:80 nginx
```

## Aprendizado
- `-d` roda em background; sem ele o terminal trava em foreground.
- `-p 8080:80` é `host:container`. Sem esse mapeamento o container fica isolado.
- `docker run` cria container **novo** toda vez — não reaproveita o anterior.
- Sem `--name`, Docker batiza com nome aleatório.

## Erro/observação
Rodei `docker run` várias vezes sem perceber que cada vez criava um container novo — fiquei com 3 containers Nginx parados. Limpei com `docker container prune`.
