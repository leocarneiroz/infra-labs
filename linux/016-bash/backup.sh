#!/bin/bash

SOURCE_DIR="/tmp/payfast-config"
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

