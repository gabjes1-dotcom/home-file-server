# 03 — Configuración de Samba (SMB)

Samba permite compartir carpetas en la red local, accesibles desde Windows, Mac y Linux.

---

## 3.1 — Instalar Samba

```bash
sudo apt install samba -y
```

---

## 3.2 — Configurar Samba

Haz un respaldo del archivo original:

```bash
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
```

Edita el archivo de configuración:

```bash
sudo nano /etc/samba/smb.conf
```

Agrega al final del archivo:

```ini
[familia]
   path = /datapool/familia
   browseable = yes
   read only = no
   guest ok = no
   create mask = 0664
   directory mask = 0775

[fotos]
   path = /datapool/familia/fotos
   browseable = yes
   read only = no
   guest ok = no
   create mask = 0664
   directory mask = 0775

[videos]
   path = /datapool/familia/videos
   browseable = yes
   read only = no
   guest ok = no
   create mask = 0664
   directory mask = 0775

[documentos]
   path = /datapool/familia/documentos
   browseable = yes
   read only = no
   guest ok = no
   create mask = 0664
   directory mask = 0775

[musica]
   path = /datapool/familia/musica
   browseable = yes
   read only = no
   guest ok = no
   create mask = 0664
   directory mask = 0775
```

---

## 3.3 — Verificar Configuración

```bash
testparm
```

Debe mostrar: `Loaded services file OK.`

---

## 3.4 — Crear Usuario Samba

```bash
sudo smbpasswd -a <TU_USUARIO>
```

> 💡 Puedes usar la misma contraseña que tu usuario del sistema.

---

## 3.5 — Configurar Permisos

```bash
sudo chown -R <TU_USUARIO>:<TU_USUARIO> /datapool/familia
sudo chmod -R 775 /datapool/familia
```

---

## 3.6 — Reiniciar Samba

```bash
sudo systemctl restart smbd
sudo systemctl status smbd
```

Debe mostrar: `smbd: ready to serve connections...`

---

## 3.7 — Abrir Firewall

```bash
sudo ufw allow ssh
sudo ufw allow samba
sudo ufw allow 9090/tcp   # Cockpit
sudo ufw enable
```

---

## 3.8 — Conectarse desde Windows

### Opción A — Explorador de Archivos
1. En la barra de dirección escribe: `\\<IP_SERVIDOR>`
2. Usuario: `<TU_USUARIO>`
3. Contraseña: tu contraseña de Samba

### Opción B — Mapear Unidad de Red
1. Clic derecho en **"Este equipo"** → **"Conectar a unidad de red"**
2. Carpeta: `\\<IP_SERVIDOR>\familia`
3. Marca ✅ **"Conectar de nuevo al iniciar sesión"**
4. Marca ✅ **"Conectar con credenciales diferentes"**

### Opción C — PowerShell (persistente)
```powershell
net use Z: \\<IP_SERVIDOR>\familia /user:<TU_USUARIO> <TU_CONTRASEÑA> /persistent:yes
```

---

## 3.9 — Conectarse desde Mac

1. Finder → `Ir` → `Conectarse al servidor`
2. Escribe: `smb://<IP_SERVIDOR>`
3. Usa tus credenciales de Samba

---

## Comandos de Referencia

```bash
sudo systemctl status smbd     # Estado del servicio
sudo systemctl restart smbd    # Reiniciar Samba
sudo smbpasswd -a <USUARIO>    # Agregar usuario
sudo smbpasswd -d <USUARIO>    # Deshabilitar usuario
testparm                       # Verificar configuración
```
