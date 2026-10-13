# 015 — Logs e Troubleshooting Linux

## Objetivo

Dominar as ferramentas de diagnóstico de sistema Linux em produção: logs, conexões de rede, processos e mensagens do kernel.

## Ferramentas cobertas

- `/var/log/` — logs clássicos (syslog, auth.log, kern.log)
- `journalctl` — journal binário do systemd
- `ss` — sockets e conexões
- `lsof` — arquivos abertos por processo
- `top` / `htop` — monitor de recursos
- `dmesg` — mensagens do kernel

## Comandos principais

```bash
# Logs clássicos
ls -la /var/log/
sudo tail -20 /var/log/auth.log
sudo tail -20 /var/log/syslog
sudo tail -20 /var/log/kern.log

# journald
sudo journalctl -b                      # boot atual
sudo journalctl -u <service>            # por serviço
sudo journalctl -p err                  # só erros
sudo journalctl --since "1 hour ago"
sudo journalctl -f                      # tempo real

# Rede
ss -tlnp                                # portas TCP escutando com processo
sudo ss -tlnp | grep 8080               # quem usa a 8080
sudo lsof -i :8080                      # alternativa ao ss

# Sistema
docker stats --no-stream <container>
sudo dmesg -T | tail -20
sudo dmesg -T | grep -i "oom\|kill"
```

## Aprendizado

- **`syslog`** é o log **geral** do sistema. **`kern.log`** é do **kernel**. **`auth.log`** é de **autenticação**. Não confundir.
- **journald é binário** — não lê com `cat`. Usa `journalctl`.
- **`ss -tlnp`**: `-t` (TCP) + `-l` (Listening) + `-n` (Numeric) + `-p` (Process).
- **`iowait` é CPU parada esperando I/O**, não CPU ativa. `wa` alto = gargalo de disco/rede.
- **`dmesg -T`** mostra timestamp legível. Sem `-T`, segundos desde boot.
- **Estados de conexão**: `LISTEN` (escutando), `ESTAB` (ativa), `TIME_WAIT` (encerrada, aguardando pacotes finais).
- **Sempre medir antes de agir** — `docker stats`, `ss`, `dmesg`, `logs`, nesta ordem.
- **OOM kill confirmado no host** via `dmesg -T | grep -i oom`. Complementa o `kubectl describe` do K8s.

## Dificuldades

- Confundi **`syslog`** com **`kern.log`** — syslog é o geral, kern.log é só do kernel.
- Inverti o conceito de **iowait** — achava que era CPU ativa, mas é CPU parada aguardando I/O.
- Não decifrei as flags do **`ss -tlnp`** na primeira tentativa.
- Não executei os comandos de fato (só descrevi teoricamente) — aprendi que a saída real revela o que a teoria não mostra.
