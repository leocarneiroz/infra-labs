# 003 — Lifecycle e restart policy

## Objetivo
Entender stop, kill, pause e restart policy.

## Comando
```bash
docker stop nginx-teste
docker start nginx-teste
docker run -d --restart=unless-stopped --name nginx-teste -p 8080:80 nginx
```

## Aprendizado
- `stop` → SIGTERM + timeout de 10s → SIGKILL. Container fica `Exited`.
- `kill` → SIGKILL direto, sem graceful shutdown. **Não remove** o container, só para.
- `pause` → SIGSTOP. Container continua `Up`, mas congelado. Volta com `unpause`.
- `start` sobe container parado. `run` cria container novo.
- Container parado some do `docker ps` (só aparece em `docker ps -a`).

## Restart policy
| Policy | Se derrubar com `stop`, reinicia? |
|---|---|
| `no` (padrão) | — |
| `always` | sim, mesmo após `stop` manual |
| `unless-stopped` | respeita `stop` manual |
| `on-failure` | só se o processo sair com erro |

## Erro/observação
`unless-stopped` é o mais comum em produção: se você parar manualmente para manutenção, não sobe sozinho num restart do daemon.
