# 01 — Instalación de Ubuntu Server 26.04 LTS

## Requisitos Previos

### Hardware necesario
- Intel NUC7i7BNH (o similar) con SSD instalado
- USB de al menos 8GB
- Monitor y teclado (solo para la instalación)
- Cable Ethernet conectado al router
- ORICO DS500 con discos instalados (**apagado y desconectado durante la instalación**)

---

## 1.1 — Descargar la ISO

Descarga Ubuntu Server 26.04 LTS desde:

> https://ubuntu.com/download/server

Archivo: `ubuntu-26.04-live-server-amd64.iso` (~2.7GB)

---

## 1.2 — Grabar el USB de Instalación

Descarga **Balena Etcher** desde https://etcher.balena.io

1. Abre Etcher e inserta el USB
2. Clic en **"Flash from file"** → selecciona el `.iso`
3. Clic en **"Select target"** → selecciona el USB
4. Clic en **"Flash!"** → espera ~5-10 minutos
5. Al terminar: **"Flash Complete!"** → expulsa el USB

> ⚠️ Windows puede mostrar un mensaje para formatear el USB al terminar — haz clic en **Cancelar**.

---

## 1.3 — Configurar Arranque desde USB

1. Conecta el USB al NUC
2. Enciende el NUC y presiona **F2** para entrar al BIOS
3. En **Boot Order** coloca **USB** como primera opción
4. Guarda con **F10** y reinicia

---

## 1.4 — Instalación de Ubuntu Server

### Configuración durante la instalación

| Opción | Valor recomendado |
|---|---|
| Idioma | English |
| Teclado | Spanish (Latin America) |
| Tipo | Ubuntu Server (no minimized) |
| Red | Ethernet — DHCP automático |
| Almacenamiento | **Solo el SSD** — NO seleccionar discos del ORICO |
| OpenSSH | ✅ Instalar |
| Snaps adicionales | Ninguno |

### Perfil de usuario

```
Nombre del servidor:  homeserver
Usuario:              <TU_USUARIO>    # No usar "admin" — está reservado
Contraseña:           <TU_CONTRASEÑA>
```

> 💡 Anota bien tu usuario y contraseña — los necesitarás para todo.

### Almacenamiento
- Selecciona **"Use an entire disk"**
- Asegúrate de seleccionar el **SSD (~128GB)**
- **NO toques los discos del ORICO**

---

## 1.5 — Primer Arranque

Al terminar la instalación y reiniciar verás la pantalla de login con información del sistema:

```
homeserver login: <TU_USUARIO>
Password:
```

> 💡 La contraseña no se muestra mientras escribes — es normal en Linux.

Anota la dirección IP que aparece en pantalla:
```
IPv4 address for eno1: 192.168.X.X
```

---

## 1.6 — Actualización del Sistema

Inicia sesión y ejecuta:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
```

---

## 1.7 — Conectarse por SSH

Desde cualquier PC en la red:

```bash
ssh <TU_USUARIO>@<IP_SERVIDOR>
```

A partir de aquí puedes administrar el servidor sin necesitar monitor ni teclado.
