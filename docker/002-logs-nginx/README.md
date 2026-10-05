# 002 — Logs de container Nginx

## Objetivo
Ler logs do Nginx e acompanhar em tempo real.

## Comando
```bash
docker logs nginx-teste        # histórico
docker logs -f nginx-teste     # follow (tempo real)
```

## Aprendizado
- Em container, aplicação escreve log em **stdout/stderr**, não em arquivo. O Docker captura e o `docker logs` exibe.
- Formato do log: `IP - - [data] "MÉTODO /path HTTP/1.1" status bytes "referer" "user-agent"`.
- IP `172.17.0.1` que aparece no log é o **gateway da bridge do Docker**, não o IP do host.
- `Ctrl+C` sai do `-f` sem derrubar o container.

## Erro/observação
