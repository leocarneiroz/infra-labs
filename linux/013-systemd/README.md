# 013 — systemd

## Objetivo

Rodar um script Python como serviço gerenciado pelo systemd, com reinício automático em caso de falha e inicialização automática no boot do sistema.

## Arquivos

**`monitor.py`**

```python
#!/usr/bin/env python3
import time
from datetime import datetime

while True:
    print(f"{datetime.now().isoformat()} - monitor ativo", flush=True)
    time.sleep(5)
```

**`payfast-monitor.service`**

```ini
[Unit]
Description=PayFast Monitor - registra atividade a cada 5 segundos
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/leonardo_carneiro/labs/linux/013-systemd
ExecStart=/usr/bin/python3 /home/leonardo_carneiro/labs/linux/013-systemd/monitor.py
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

## Comandos

```bash
# Copiar pro systemd (área do root)
sudo cp payfast-monitor.service /etc/systemd/system/
sudo chmod 644 /etc/systemd/system/payfast-monitor.service

# Recarregar e subir
sudo systemctl daemon-reload
sudo systemctl start payfast-monitor
sudo systemctl status payfast-monitor

# Habilitar no boot
sudo systemctl enable payfast-monitor

# Ler logs
sudo journalctl -u payfast-monitor -f
sudo journalctl -u payfast-monitor -n 50 --no-pager

# Teste de resiliência
sudo pkill -9 -f monitor.py
sleep 5
sudo systemctl status payfast-monitor
```

## Resultado

Serviço rodou como esperado. Após o `pkill -9`, o systemd reiniciou automaticamente (Main PID mudou de `15660` para `15747`), provando que o `Restart=on-failure` está funcionando. Serviço habilitado no boot via `enable`.

## Aprendizado

- **`start` vs `enable`**: `start` sobe o serviço agora. `enable` configura para subir no próximo boot (não sobe agora). Existe também `enable --now`, que faz os dois.
- **`WantedBy=multi-user.target`**: quando você roda `systemctl enable`, o systemd cria um symlink em `/etc/systemd/system/multi-user.target.wants/`. No boot, quando o sistema entra em `multi-user.target` (modo servidor sem GUI), ele lê essa pasta e inicia tudo que está lá.
- **`daemon-reload`**: o systemd carrega os unit files em cache na memória. Se você editar um unit file, ele **não percebe sozinho** — continua usando a versão antiga. O `sudo systemctl daemon-reload` invalida o cache e força releitura. Sempre que alterar um unit file: `edita → daemon-reload → restart`.
- **`/etc/systemd/system/` é área do root**: não pode ser editado como usuário comum. Fluxo correto: editar o unit file no lab versionado, depois `sudo cp` pro systemd.
- **`Restart=on-failure`** reinicia em caso de falha (exit code ≠ 0 ou sinais "ruins" tipo SIGKILL, SIGSEGV). **NÃO reinicia em SIGTERM** — o systemd interpreta SIGTERM como desligamento intencional, não como falha.
- **Logs modernos vão pro journald**: a aplicação imprime em `stdout`, o systemd captura, e o `journalctl -u <service>` mostra. Não precisa mais escrever arquivo de log manualmente (padrão 2026).

## Dificuldades

- **`PermissionError` ao escrever em `/tmp`**: o arquivo `/tmp/payfast-monitor.log` foi criado no teste manual com dono `leonardo`, e o systemd (rodando em outro contexto) não conseguia escrever. Diagnosticado com `journalctl -u payfast-monitor -n 50` — o traceback do Python estava lá. **Solução:** migrar para journald (`print` no stdout) em vez de arquivo.
- **VSCode não escreve em `/etc/`**: a pasta pertence ao root. Fluxo correto é editar o arquivo versionado no lab e copiar com `sudo cp`.
- **Teste de resiliência com `pkill` (sem `-9`) não reiniciou o serviço**: descobri que `pkill` normal envia SIGTERM, e o systemd trata SIGTERM como "parada intencional". Só o `pkill -9` (SIGKILL) provou que o `Restart=on-failure` funciona.