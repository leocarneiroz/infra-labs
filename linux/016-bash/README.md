# 016 — Bash script com rotação de backups

## Objetivo

Automatizar rotina de backup: compactar um diretório de configs, manter apenas os 7 backups mais recentes e registrar cada etapa num arquivo de log. Script preparado para ser chamado por systemd.timer (cron moderno).

## Script

**`backup.sh`**

```bash
#!/bin/bash

SOURCE_DIR="${1:-/tmp/payfast-config}"
BACKUP_DIR="$HOME/labs/linux/016-bash/backup"
RETENTION_DAYS=7
LOG_FILE="$BACKUP_DIR/backup.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

set -euo pipefail

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

log "Iniciando o backup do diretório: $SOURCE_DIR"

if [ ! -d "$SOURCE_DIR" ]; then
    log "Diretório de origem não encontrado: $SOURCE_DIR"
    exit 1
fi

if tar -czf "$BACKUP_DIR/backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz" -C "$SOURCE_DIR" .; then
    log "Backup realizado com sucesso."
else
    log "Falha ao realizar o backup."
    exit 1
fi

TO_DELETE=$(find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -printf '%T@ %p\n' | sort -rn | cut -d' ' -f2- | tail -n +$((RETENTION_DAYS + 1)))

log "Removendo: $TO_DELETE"

echo "$TO_DELETE" | xargs -r rm

log "Backup concluído com sucesso."

exit 0
```

## Comandos de teste

```bash
# Torna executável
chmod +x backup.sh

# Roda com sucesso
./backup.sh
echo "Exit code: $?"          # esperado: 0

# Testa erro (diretório inexistente)
./backup.sh /tmp/nao-existe
echo "Exit code: $?"          # esperado: 1

# Testa rotação: cria 10 arquivos antigos e roda
for i in {1..10}; do
    touch "$HOME/labs/linux/016-bash/backup/backup_2026-01-0${i}_00-00-00.tar.gz"
done
./backup.sh
ls ~/labs/linux/016-bash/backup/*.tar.gz | wc -l   # esperado: 8

# Linter
shellcheck backup.sh
```

## Aprendizado

- **Funções Bash precisam ser definidas ANTES da primeira chamada.** Bash executa o script de cima pra baixo — se `log()` é chamada antes da definição, dá `command not found`.
- **`set -euo pipefail`**:
  - `-e` → sai se qualquer comando falhar
  - `-u` → erro ao usar variável não definida
  - `-o pipefail` → se uma parte do pipe falhar, o pipe todo falha
  - **Com `set -e`**, checar `$?` logo depois do comando vira código morto — o script já morreu se falhou.
- **Rotação por idade ≠ rotação por contagem**:
  - `find -mtime +7` → apaga arquivos com mais de 7 **dias**
  - Contagem → ordena por tempo (`sort -rn`) + pula os N primeiros (`tail -n +N`) → mantém os N mais recentes
  - O ticket pede **contagem**, não idade.
- **`~` não expande dentro de aspas duplas.** Usar `$HOME` ou caminho absoluto.
- **`$(date +FORMATO)`** — o `+` é **obrigatório**. Sem ele, o `date` interpreta como formato literal.
- **`${1:-padrão}`** aceita argumento com fallback (se `$1` não existir, usa o padrão).
- **`xargs -r`** — o `-r` (ou `--no-run-if-empty`) evita rodar o comando quando não há entrada. Sem ele, `xargs rm` sem nada pra apagar roda `rm` sem argumentos — o que pode causar problemas.
- **`echo $?`** roda **no terminal, DEPOIS do script** — não dentro dele. Dentro do script, `$?` reflete o último comando executado naquele ponto.
- **Linter (`shellcheck`) antes de rodar.** Pega erro de sintaxe, aspas faltando, variáveis não citadas.

## Dificuldades

- **Função `log()` chamada antes de ser definida** — Bash não faz "hoisting" como JavaScript. Ordem importa.
- **Duplicação da linha do `tar`** — copiei um `if tar ...; then` de exemplo com `...` literal, achando que era pra colar. Sintaxe inválida (`date ...`).
- **Rotação por `-mtime` em vez de contagem** — apaguei por idade, não por quantidade. Só funciona se você roda o script uma vez por dia.
- **`exit 1` fantasma** dentro do bloco `if` do `mkdir` — fazia o script sair mesmo quando o diretório foi criado com sucesso.
- **`echo "Código de retorno: $?"` dentro do script** — achava que era parte do teste, mas estava imprimindo o exit code do shell pai, não do script.
- **`SOURCE_DIR` hardcoded** — não aceitava argumento por linha de comando até usar `${1:-...}`.
