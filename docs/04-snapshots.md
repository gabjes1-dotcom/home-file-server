# 04 — Snapshots Automáticos con ZFS

Los snapshots son copias instantáneas del estado de tus datos. Si alguien borra un archivo accidentalmente, puedes recuperarlo de un snapshot anterior.

---

## 4.1 — Instalar zfs-auto-snapshot

```bash
sudo apt install zfs-auto-snapshot -y
```

---

## 4.2 — Configurar Política de Snapshots

Edita el archivo de configuración:

```bash
sudo nano /etc/cron.d/zfs-auto-snapshot
```

Reemplaza el contenido con:

```
PATH="/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

# Cada 15 minutos — guarda 4 snapshots (última hora)
*/15 * * * * root which zfs-auto-snapshot > /dev/null || exit 0 ; zfs-auto-snapshot --quiet --syslog --label=frequent --keep=4 //

# Cada hora — guarda 24 snapshots (último día)
0 * * * * root which zfs-auto-snapshot > /dev/null || exit 0 ; zfs-auto-snapshot --quiet --syslog --label=hourly --keep=24 //

# Diario — guarda 30 snapshots (último mes)
0 0 * * * root which zfs-auto-snapshot > /dev/null || exit 0 ; zfs-auto-snapshot --quiet --syslog --label=daily --keep=30 //

# Semanal — guarda 8 snapshots (2 meses)
0 0 * * 0 root which zfs-auto-snapshot > /dev/null || exit 0 ; zfs-auto-snapshot --quiet --syslog --label=weekly --keep=8 //

# Mensual — guarda 12 snapshots (1 año)
0 0 1 * * root which zfs-auto-snapshot > /dev/null || exit 0 ; zfs-auto-snapshot --quiet --syslog --label=monthly --keep=12 //
```

---

## 4.3 — Política de Retención

| Frecuencia | Cantidad | Cobertura |
|---|---|---|
| Cada 15 minutos | 4 snapshots | Última hora |
| Cada hora | 24 snapshots | Último día |
| Diario | 30 snapshots | Último mes |
| Semanal | 8 snapshots | Últimos 2 meses |
| Mensual | 12 snapshots | Último año |

---

## 4.4 — Verificar Snapshots

```bash
sudo zfs list -t snapshot
```

Resultado esperado:
```
NAME                                                    USED  AVAIL
datapool@zfs-auto-snap_frequent-2026-06-05-0415           0B      -
datapool/familia@zfs-auto-snap_frequent-2026-06-05-0415   0B      -
datapool/familia/fotos@zfs-auto-snap_frequent-...          0B      -
...
```

---

## 4.5 — Recuperar un Archivo Borrado

Los snapshots se almacenan en una carpeta oculta `.zfs/snapshot` dentro de cada dataset.

```bash
ls /datapool/familia/.zfs/snapshot/
```

Para recuperar un archivo:

```bash
# Ver los archivos en un snapshot específico
ls /datapool/familia/.zfs/snapshot/zfs-auto-snap_daily-2026-06-05-0000/

# Copiar el archivo recuperado
cp /datapool/familia/.zfs/snapshot/<NOMBRE_SNAPSHOT>/archivo.txt /datapool/familia/archivo_recuperado.txt
```

---

## 4.6 — Snapshot Manual

```bash
sudo zfs-auto-snapshot --quiet --syslog --label=manual --keep=1 //
```

---

## Comandos de Referencia

```bash
sudo zfs list -t snapshot                    # Listar snapshots
sudo zfs destroy datapool@<snapshot>         # Eliminar snapshot específico
sudo zfs rollback datapool/familia@<snap>    # Revertir dataset a snapshot
```

> ⚠️ `zfs rollback` revierte **todos** los cambios desde el snapshot — úsalo con cuidado.
