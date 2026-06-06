# 06 — Configuración de Red

---

## 6.1 — Identificar la Interfaz de Red

```bash
ip a
```

Busca la interfaz ethernet, normalmente `eno1` o `enp3s0`:

```
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 192.168.X.X/24
```

---

## 6.2 — Configurar IP Fija

Edita el archivo de Netplan:

```bash
sudo nano /etc/netplan/50-cloud-init.yaml
```

Reemplaza el contenido con:

```yaml
network:
  version: 2
  ethernets:
    eno1:                          # Cambia según tu interfaz
      dhcp4: no
      addresses:
        - 192.168.X.100/24         # IP que quieres asignar
      routes:
        - to: default
          via: 192.168.X.1         # IP de tu router/gateway
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

Ajusta los permisos y aplica:

```bash
sudo chmod 600 /etc/netplan/50-cloud-init.yaml
sudo netplan apply
```

Verifica:

```bash
ip a show eno1
```

---

## 6.3 — Consideraciones de Red

### Topología recomendada

```
Internet → Módem → Router principal → Switch → NUC (servidor)
                                             → PCs de la familia
```

> 💡 Conectar el servidor **directamente al router o switch** (no a través de repetidores WiFi o expansores) garantiza máximo rendimiento.

### Velocidades esperadas

| Conexión | Velocidad aprox. |
|---|---|
| Gigabit Ethernet (cable) | ~111 MB/s |
| WiFi 5GHz | ~50-70 MB/s |
| WiFi 2.4GHz | ~10-20 MB/s |
| Expansor/repetidor | ~5-15 MB/s |

---

## 6.4 — Redes Deco (TP-Link Mesh)

Si usas un sistema Deco TP-Link, asegúrate de que el servidor esté en la **misma subred** que los dispositivos de la familia.

Los sistemas Deco pueden operar en dos modos:
- **Modo Router** — crea su propia subred (ej. `192.168.68.x`)
- **Modo Access Point** — usa la subred del router principal

Si el servidor y los clientes están en subredes diferentes, no se verán. Soluciones:
1. Conectar el servidor al mismo segmento de red que los clientes
2. Usar un switch adicional conectado al Deco
3. Configurar el Deco en modo Access Point

---

## 6.5 — Firewall UFW

```bash
sudo ufw allow ssh          # Acceso remoto SSH
sudo ufw allow samba        # Compartición de archivos
sudo ufw allow 9090/tcp     # Panel Cockpit
sudo ufw enable
```

Verificar estado:

```bash
sudo ufw status
```

---

## Comandos de Referencia

```bash
ip a                        # Ver interfaces y direcciones IP
ip route                    # Ver tabla de rutas
sudo netplan apply          # Aplicar cambios de red
sudo ufw status             # Estado del firewall
ping <IP>                   # Verificar conectividad
```
