#!/bin/bash
# Script de backup do servidor (mundo + configs)
# Funciona com qualquer loader (Forge, NeoForge, Fabric) — não depende do nome do .jar
#
# Uso: ./backup-world.sh [pasta-do-servidor] [pasta-de-backups] [quantidade-a-manter]
# Exemplo: ./backup-world.sh ~/minecraft-server ~/backups 7
#
# Dica: para automatizar, adicione ao crontab (backup diário às 4h):
#   0 4 * * * /home/ubuntu/minecraft-server/backup-world.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SERVER_DIR=${1:-$(pwd)}
BACKUP_DIR=${2:-"$HOME/backups"}
KEEP=${3:-7}   # quantos backups manter por padrão

echo -e "${GREEN}=== Backup do Servidor ===${NC}"

if [ ! -d "$SERVER_DIR" ]; then
    echo -e "${RED}Erro: pasta do servidor não encontrada: ${SERVER_DIR}${NC}"
    exit 1
fi

mkdir -p "$BACKUP_DIR"
cd "$SERVER_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.tar.gz"

# Monta a lista de itens a incluir, ignorando os que não existirem nesse modpack/loader
ITEMS=()
for item in world config server.properties mods datapacks eula.txt; do
    [ -e "$item" ] && ITEMS+=("$item")
done

if [ ${#ITEMS[@]} -eq 0 ]; then
    echo -e "${RED}Erro: nenhum arquivo/pasta esperado encontrado em ${SERVER_DIR}${NC}"
    echo "Confirme que está apontando para a pasta correta do servidor."
    exit 1
fi

echo -e "${YELLOW}Compactando: ${ITEMS[*]}${NC}"
tar -czf "$BACKUP_FILE" "${ITEMS[@]}"

SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
echo -e "${GREEN}Backup criado: ${BACKUP_FILE} (${SIZE})${NC}"

# Limpeza: mantém só os N backups mais recentes
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)
if [ "$BACKUP_COUNT" -gt "$KEEP" ]; then
    echo -e "${YELLOW}Removendo backups antigos (mantendo os ${KEEP} mais recentes)...${NC}"
    ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +"$((KEEP + 1))" | xargs -r rm
fi

echo -e "${GREEN}=== Backup completo! ===${NC}"
echo "Total de backups mantidos: $(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)"
