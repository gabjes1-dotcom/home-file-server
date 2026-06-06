# 🏠 Home File Server — NUC + ORICO DS500 + ZFS + Samba

Servidor de archivos doméstico de alto rendimiento con protección RAID-Z2, snapshots automáticos y compartición de archivos en red local.

> Proyecto documentado paso a paso, desde cero, orientado a usuarios principiantes en Linux.

---

## 📋 Descripción del Proyecto

Implementación de un servidor de archivos para uso familiar en casa, basado en una minicomputadora Intel NUC i7 y un arreglo de 4 discos duros externos. El sistema ofrece:

- **Alta disponibilidad** — RAID-Z2 tolera la falla simultánea de 2 discos
- **Protección de datos** — Snapshots automáticos ZFS cada 15 minutos, hora, día, semana y mes
- **Compartición en red** — Acceso desde Windows, Mac y Linux via Samba (SMB)
- **Panel de administración web** — Cockpit accesible desde el navegador
- **Backups incrementales** — Restic con retención configurable
- **Rendimiento** — ~111 MB/s de transferencia en red Gigabit Ethernet

---

## 🖥️ Hardware Utilizado

| Componente | Modelo | Descripción |
|---|---|---|
| Minicomputadora | Intel NUC7i7BNH | Core i7-7567U 3.5GHz, hasta 32GB RAM |
| Almacenamiento OS | SSD 128GB (SATA 2.5") | Sistema operativo |
| Enclosure | ORICO DS500 | 5 bahías USB 3.0, chip JMicron JMS567 |
| Discos de datos | 4 × HDD 1TB | Arreglo RAID-Z2 |
| Red | Gigabit Ethernet | Conexión directa al router |

---

## 🏗️ Arquitectura del Sistema

```
┌─────────────────────────────────────────┐
│           Intel NUC7i7BNH               │
│                                         │
│  ┌─────────────┐    ┌────────────────┐  │
│  │ SSD 128GB   │    │  Ubuntu Server │  │
│  │ (Sistema OS)│    │   26.04 LTS    │  │
│  └─────────────┘    └────────────────┘  │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │         ZFS RAID-Z2             │    │
│  │  ┌──────┐┌──────┐┌──────┐┌────┐│    │
│  │  │ HDD  ││ HDD  ││ HDD  ││HDD ││    │
│  │  │  1TB ││  1TB ││  1TB ││ 1TB││    │
│  │  └──────┘└──────┘└──────┘└────┘│    │
│  │         ORICO DS500 USB 3.0     │    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
           │ Gigabit Ethernet
           │
    ┌──────┴──────┐
    │    Router   │
    └──────┬──────┘
           │
    ┌──────┴──────────────────┐
    │   Dispositivos familia  │
    │  Windows / Mac / Linux  │
    └─────────────────────────┘
```

---

## 📦 Stack Tecnológico

| Capa | Tecnología | Versión |
|---|---|---|
| Sistema Operativo | Ubuntu Server | 26.04 LTS (Resolute Raccoon) |
| Kernel | Linux | 7.0.0 |
| Sistema de Archivos | ZFS | 2.4.1 |
| RAID | RAID-Z2 (software) | — |
| Compartición de Archivos | Samba (SMB) | 4.23.6 |
| Panel de Administración | Cockpit | 360 |
| Backups | Restic | 0.18.1 |
| Snapshots | zfs-auto-snapshot | 1.2.4 |
| Firewall | UFW | — |

---

## 📁 Estructura de Carpetas

```
/datapool/
└── familia/
    ├── fotos/
    ├── videos/
    ├── documentos/
    └── musica/
```

Cada carpeta es un **dataset ZFS independiente** con sus propios snapshots.

---

## 🚀 Capacidad y Rendimiento

| Métrica | Valor |
|---|---|
| Discos totales | 4 × 1TB = 4TB |
| Espacio utilizable (RAID-Z2) | ~1.75TB |
| Tolerancia a fallos | 2 discos simultáneos |
| Velocidad de escritura (red Gigabit) | ~111 MB/s |
| Velocidad interna ZFS | ~341 MB/s |

---

## 📚 Documentación

| Documento | Descripción |
|---|---|
| [Instalación](docs/01-instalacion.md) | Instalación de Ubuntu Server 26.04 LTS |
| [Configuración ZFS](docs/02-zfs.md) | Pool RAID-Z2, datasets y optimización |
| [Samba](docs/03-samba.md) | Compartición de archivos en red |
| [Snapshots](docs/04-snapshots.md) | Protección automática de datos |
| [Backups](docs/05-backups.md) | Backups incrementales con Restic |
| [Red](docs/06-red.md) | IP fija y configuración de red |
| [Cockpit](docs/07-cockpit.md) | Panel de administración web |
| [Troubleshooting](docs/08-troubleshooting.md) | Problemas comunes y soluciones |
| [Scripts](scripts/) | Scripts de automatización |

---

## ⚡ Acceso Rápido

```
Panel Web:     https://<IP_SERVIDOR>:9090
Carpetas SMB:  \\<IP_SERVIDOR>\familia
SSH:           ssh <USUARIO>@<IP_SERVIDOR>
```

---

## 📜 Licencia

MIT License — libre para usar, modificar y distribuir.

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Si encuentras algún error o tienes mejoras, abre un Issue o Pull Request.
