# 08 — Troubleshooting

Problemas comunes encontrados durante la implementación y sus soluciones.

---

## El servidor no arranca después de moverlo

**Síntoma:** El NUC se apaga solo al intentar cargar Ubuntu.

**Causas posibles:**
1. Fuente de poder incorrecta — el NUC7i7BNH requiere **19V**
2. Módulo de RAM suelto al mover el equipo
3. initramfs corrupto

**Solución:**
1. Verifica que estás usando la fuente original del NUC (19V)
2. Abre el NUC y verifica que los módulos RAM estén bien sentados
3. Si el problema persiste, arranca desde el USB de instalación en modo rescue

---

## El pool ZFS no aparece después de reiniciar

**Síntoma:** `sudo zpool status` muestra `no pools available`

**Causa:** El pool no se importó automáticamente.

**Solución inmediata:**
```bash
sudo zpool import datapool
```

**Solución permanente:**
```bash
sudo zpool set cachefile=/etc/zfs/zpool.cache datapool
sudo systemctl enable zfs-import-cache.service
sudo systemctl enable zfs-mount.service
```

---

## El disco del ORICO está ocupado al intentar wipefs

**Síntoma:** `wipefs: error: /dev/sdb: probing initialization failed: Device or resource busy`

**Causa:** El disco tiene un LVM activo.

**Solución:**
```bash
sudo lvchange -an ubuntu-vg/ubuntu-lv
sudo vgchange -an ubuntu-vg
sudo wipefs -a /dev/sdb /dev/sdc /dev/sdd /dev/sde
```

---

## No se puede acceder a Cockpit desde el navegador

**Síntoma:** `https://<IP>:9090` no carga.

**Causa:** Puerto 9090 no abierto en el firewall.

**Solución:**
```bash
sudo ufw allow 9090/tcp
sudo ufw reload
```

---

## El servidor no responde al ping desde otras PCs

**Síntoma:** `ping <IP_SERVIDOR>` devuelve "Host de destino inaccesible"

**Causas posibles:**
1. El servidor y los clientes están en subredes diferentes
2. IP fija configurada en el rango incorrecto

**Diagnóstico:**
- Verifica que la IP del servidor y la de los clientes sean del mismo rango (ej. ambas en `192.168.100.x`)
- Verifica con `ipconfig` (Windows) o `ip a` (Linux) las IPs de cada dispositivo

**Solución:**
Actualiza la IP fija del servidor al rango correcto en `/etc/netplan/50-cloud-init.yaml`

---

## Velocidad de transferencia lenta (~10 MB/s)

**Síntoma:** Las copias de archivos desde la PC al servidor son lentas.

**Causas posibles:**
1. Conexión WiFi en lugar de Ethernet
2. Servidor conectado a expansor/repetidor de red
3. Red 2.4GHz en lugar de 5GHz

**Diagnóstico:**
```bash
# En el servidor — prueba velocidad interna de los discos
dd if=/dev/zero of=/datapool/familia/testfile bs=1M count=1024 conv=fdatasync
rm /datapool/familia/testfile
```

Si la velocidad interna es alta (~300+ MB/s) pero la transferencia por red es lenta, el problema es la red, no los discos.

**Solución:** Conecta el servidor directamente al router principal por cable Ethernet.

---

## Servicio grub-initrd-fallback fallido

**Síntoma:** `sudo systemctl --failed` muestra `grub-initrd-fallback.service`

**Causa:** Reinicios abruptos por problemas de energía.

**Solución:**
```bash
sudo systemctl reset-failed grub-initrd-fallback.service
sudo systemctl start grub-initrd-fallback.service
```

---

## Error al pegar comandos en la terminal

**Síntoma:** Los comandos copiados se ejecutan duplicados o con caracteres extra.

**Causa:** El portapapeles pega el texto dos veces o con caracteres adicionales.

**Solución:** Escribe los comandos manualmente en lugar de copiarlos, especialmente comandos cortos.

---

## No puedo usar "admin" como nombre de usuario

**Síntoma:** El instalador de Ubuntu no permite el usuario "admin".

**Causa:** "admin" es un nombre reservado en Ubuntu.

**Solución:** Usa un nombre alternativo como `adminjr`, `adminuser`, o tu nombre personal.

---

## Diagnóstico General

```bash
sudo systemctl --failed              # Servicios con errores
sudo zpool status                    # Estado de los discos
sudo zfs list                        # Datasets y espacio
sudo systemctl status smbd           # Estado de Samba
sudo ufw status                      # Estado del firewall
sudo journalctl -xe                  # Logs del sistema
```
