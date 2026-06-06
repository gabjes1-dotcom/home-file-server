#!/bin/bash
# =============================================================================
# backup-familia.sh — Backup incremental con Restic
# =============================================================================
# Descripción: Script de backup automático para el servidor de archivos familiar
# Autor:       Proyecto Home File Server
# Uso:         sudo /usr/local/bin/backup-familia.sh
# Cron:        0 3 * * * /usr/local/bin/backup-familia.sh >> /var/log/backup-familia.log 2>&1
# =============================================================================

# Configuración — modifica estos valores
export RESTIC_REPOSITORY=/backup/restic
export RESTIC_PASSWORD="<TU_CONTRASEÑA_RESTIC>"

# Directorio a respaldar
BACKUP_SOURCE=/datapool/familia

# Log
LOG_DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$LOG_DATE] Iniciando backup..."

# Verificar que el repositorio existe
if ! restic snapshots &>/dev/null; then
    echo "[$LOG_DATE] ERROR: No se puede acceder al repositorio. Verifica la contraseña."
    exit 1
fi

# Hacer backup
echo "[$LOG_DATE] Respaldando $BACKUP_SOURCE..."
restic backup $BACKUP_SOURCE

if [ $? -eq 0 ]; then
    echo "[$LOG_DATE] Backup completado exitosamente."
else
    echo "[$LOG_DATE] ERROR: El backup falló."
    exit 1
fi

# Eliminar backups antiguos según política de retención
echo "[$LOG_DATE] Aplicando política de retención..."
restic forget \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 12 \
    --prune

# Verificar integridad del repositorio
echo "[$LOG_DATE] Verificando integridad del repositorio..."
restic check

if [ $? -eq 0 ]; then
    echo "[$LOG_DATE] Verificación exitosa. Sin errores."
else
    echo "[$LOG_DATE] ADVERTENCIA: Se encontraron errores en la verificación."
fi

echo "[$LOG_DATE] Proceso de backup finalizado."
