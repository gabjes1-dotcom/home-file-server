# 07 — Panel de Administración Cockpit

Cockpit es un panel web que permite administrar el servidor visualmente desde el navegador, sin necesidad de usar la terminal para el día a día.

---

## 7.1 — Instalar Cockpit

```bash
sudo apt install cockpit -y
```

---

## 7.2 — Activar Cockpit

```bash
sudo systemctl enable --now cockpit.socket
```

Verificar:

```bash
sudo systemctl status cockpit.socket
```

Debe mostrar: `active (listening)`

---

## 7.3 — Acceder al Panel

Abre tu navegador y ve a:

```
https://<IP_SERVIDOR>:9090
```

> ⚠️ El navegador mostrará una advertencia de seguridad por el certificado auto-firmado. Haz clic en **"Avanzado"** → **"Continuar"**.

Inicia sesión con tu usuario y contraseña del sistema.

---

## 7.4 — Funcionalidades Principales

| Sección | Descripción |
|---|---|
| **Overview** | CPU, memoria, disco, red en tiempo real |
| **Logs** | Logs del sistema |
| **Storage** | Gestión de discos y sistemas de archivos |
| **Networking** | Configuración de red |
| **Accounts** | Gestión de usuarios |
| **Services** | Estado de servicios (Samba, ZFS, etc.) |
| **Updates** | Actualizaciones del sistema |
| **Terminal** | Terminal web integrada |

---

## 7.5 — Abrir Puerto en Firewall

```bash
sudo ufw allow 9090/tcp
```

---

## 7.6 — Verificar Estado

```bash
sudo systemctl status cockpit.socket
```

---

## Comandos de Referencia

```bash
sudo systemctl start cockpit.socket      # Iniciar
sudo systemctl stop cockpit.socket       # Detener
sudo systemctl restart cockpit.socket    # Reiniciar
sudo systemctl enable cockpit.socket     # Habilitar al arranque
```
