# 02 — Configuración ZFS RAID-Z2

## ¿Por qué ZFS?

ZFS ofrece las siguientes ventajas sobre sistemas de archivos tradicionales:

- **Checksums** — detecta y corrige corrupción de datos automáticamente
- **Snapshots** — copias instantáneas del estado de los datos
- **RAID-Z2** — protección contra falla de hasta 2 discos simultáneos
- **Compresión** — ahorra espacio sin impacto notable en rendimiento
- **Auto-reparación** — detecta y corrige errores en segundo plano

---

## 2.1 — Conectar el Enclosure

1. Instala los discos en el ORICO DS500
2. Conecta el cable de poder al enclosure
3. **Enciende el ORICO primero** y espera 20 segundos
4. Conecta el cable USB 3.0 al NUC

> ⚠️ Siempre enciende el ORICO **antes** que el NUC para que los discos estén girando cuando Linux los detecte.

---

## 2.2 — Instalar ZFS

```bash
sudo apt install zfsutils-linux -y
```

---

## 2.3 — Identificar los Discos

```bash
lsblk
```

Busca los 4 discos de ~1TB del ORICO. Ejemplo:

```
sdb    931.5G  0 disk    ← disco 1 ORICO
sdc    931.5G  0 disk    ← disco 2 ORICO
sdd    931.5G  0 disk    ← disco 3 ORICO
sde    931.5G  0 disk    ← disco 4 ORICO
sda    119.2G  0 disk    ← SSD del sistema (NO tocar)
```

---

## 2.4 — Limpiar los Discos

> ⚠️ Este proceso **borra todos los datos** de los discos del ORICO.

Si los discos tienen particiones previas:

```bash
sudo lvchange -an ubuntu-vg/ubuntu-lv  # Solo si existe LVM
sudo vgchange -an ubuntu-vg            # Solo si existe LVM
sudo wipefs -a /dev/sdb /dev/sdc /dev/sdd /dev/sde
```

---

## 2.5 — Crear el Pool RAID-Z2

```bash
sudo zpool create -f datapool raidz2 /dev/sdb /dev/sdc /dev/sdd /dev/sde
```

Verifica que se creó correctamente:

```bash
sudo zpool status
```

Resultado esperado:
```
  pool: datapool
 state: ONLINE
config:
    NAME        STATE     READ WRITE CKSUM
    datapool    ONLINE       0     0     0
      raidz2-0  ONLINE       0     0     0
        sdb     ONLINE       0     0     0
        sdc     ONLINE       0     0     0
        sdd     ONLINE       0     0     0
        sde     ONLINE       0     0     0
errors: No known data errors
```

---

## 2.6 — Optimizar el Pool

```bash
sudo zfs set compression=lz4 datapool      # Compresión eficiente
sudo zfs set recordsize=1M datapool        # Optimizado para archivos grandes
sudo zfs set atime=off datapool            # Mejora rendimiento
```

---

## 2.7 — Crear Datasets

```bash
sudo zfs create datapool/familia
sudo zfs create datapool/familia/fotos
sudo zfs create datapool/familia/videos
sudo zfs create datapool/familia/documentos
sudo zfs create datapool/familia/musica
```

Verifica:

```bash
sudo zfs list
```

---

## 2.8 — Importación Automática al Arranque

Para que el pool se importe automáticamente en cada reinicio:

```bash
sudo zpool set cachefile=/etc/zfs/zpool.cache datapool
sudo systemctl enable zfs-import-cache.service
sudo systemctl enable zfs-mount.service
```

---

## 2.9 — Scrub Programado

El scrub verifica y corrige errores en todos los datos. Se configura automáticamente con la instalación de `zfsutils-linux`:

```bash
cat /etc/cron.d/zfsutils-linux
```

Para ejecutar un scrub manual:

```bash
sudo zpool scrub datapool
sudo zpool status  # Verifica el resultado
```

---

## Comandos de Referencia

```bash
sudo zpool status          # Estado del pool
sudo zpool list            # Espacio disponible
sudo zfs list              # Listar datasets
sudo zfs list -t snapshot  # Listar snapshots
sudo zpool scrub datapool  # Verificar integridad
```
