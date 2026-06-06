# 05 — Backups Incrementales con Restic

Restic proporciona backups incrementales, encriptados y eficientes. Complementa los snapshots ZFS con una capa adicional de protección.

---

## 5.1 — Instalar Restic

```bash
sudo apt install restic -y
```

---

## 5.2 — Crear Repositorio de Backup

```bash
sudo mkdir -p /backup/restic
sudo restic init --repo /backup/restic
```

> ⚠️ Guarda la contraseña del repositorio en un lugar seguro. Sin ella no podrás restaurar los backups.

---

## 5.3 — Crear Script de Backup

```bash
sudo nano /usr/local/bin/backup-familia.sh
```

Contenido del script:

```bash
#!/bin/bash
export RESTIC_REPOSITORY=/backup/restic
export RESTIC_PASSWORD="<TU_CONTRASEÑA_RESTIC>"

# Hacer backup
restic backup /datapool/familia

# Eliminar backups antiguos
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --prune

# Verificar integridad del repositorio
restic check
```

> ⚠️ Reemplaza `<TU_CONTRASEÑA_RESTIC>` con tu contraseña real.

Dar permisos de ejecución:

```bash
sudo chmod +x /usr/local/bin/backup-familia.sh
```

---

## 5.4 — Probar el Backup

```bash
sudo /usr/local/bin/backup-familia.sh
```

Resultado esperado:
```
repository opened (version 2)
snapshot XXXXXXXX saved
no errors were found
```

---

## 5.5 — Programar Backup Automático

```bash
sudo crontab -e
```

Agrega esta línea al final:

```
0 3 * * * /usr/local/bin/backup-familia.sh >> /var/log/backup-familia.log 2>&1
```

Esto ejecuta el backup **todos los días a las 3:00am**.

---

## 5.6 — Política de Retención

| Período | Backups guardados |
|---|---|
| Diario | 7 días |
| Semanal | 4 semanas |
| Mensual | 12 meses |

---

## 5.7 — Restaurar un Backup

### Listar snapshots disponibles:
```bash
sudo restic -r /backup/restic snapshots
```

### Restaurar un snapshot completo:
```bash
sudo restic -r /backup/restic restore <SNAPSHOT_ID> --target /datapool/familia
```

### Restaurar un archivo específico:
```bash
sudo restic -r /backup/restic restore <SNAPSHOT_ID> --target /tmp/restaurado --include /datapool/familia/fotos/archivo.jpg
```

---

## 5.8 — Verificar Log de Backups

```bash
cat /var/log/backup-familia.log
```

---

## 5.9 — Backup en Disco Externo (Recomendado)

Para mayor seguridad, conecta un disco USB externo adicional y apunta el repositorio a él:

```bash
export RESTIC_REPOSITORY=/mnt/backup-externo/restic
```

> 💡 La regla **3-2-1** recomienda: 3 copias, en 2 medios diferentes, 1 fuera del sitio.

---

## Comandos de Referencia

```bash
sudo restic -r /backup/restic snapshots          # Listar snapshots
sudo restic -r /backup/restic check              # Verificar integridad
sudo restic -r /backup/restic stats              # Estadísticas del repositorio
sudo restic -r /backup/restic forget --prune     # Limpiar snapshots antiguos
```
