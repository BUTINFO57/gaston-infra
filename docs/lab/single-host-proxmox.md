# 🧪 LAB — Single-Host Proxmox

## Prérequis

- 1 PC / serveur avec 16+ Go RAM, 256+ Go SSD, 1 NIC réseau
- ISO Proxmox VE 9.0 sur clé USB
- Accès Internet (pour téléchargements)

## Étape 1 — Installer Proxmox VE

1. Boot sur la clé USB Proxmox
2. Configuration :

| Paramètre | Valeur |
|:----------|:-------|
| Disque | SSD principal, ZFS ou ext4 |
| Hostname | `pve-lab.gaston.local` |
| IP | `192.168.10.11/24` |
| Gateway | `192.168.10.1` (sera pfSense) |
| DNS | `192.168.10.1` (provisoire) |

1. Post-install — désactiver le repo enterprise :

```bash
sed -i 's/^deb/# deb/' /etc/apt/sources.list.d/pve-enterprise.list
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" \
  > /etc/apt/sources.list.d/pve-no-sub.list
apt update && apt full-upgrade -y
```

## Étape 2 — Créer les bridges VLAN

En LAB, **les bridges Proxmox remplacent le switch physique**.

Éditer `/etc/network/interfaces` :

```text
auto lo
iface lo inet loopback

# Interface physique
auto eno1
iface eno1 inet manual

# Bridge principal — VLAN-aware
auto vmbr0
iface vmbr0 inet static
    address 192.168.10.11/24
    gateway 192.168.10.1
    bridge-ports eno1
    bridge-stp off
    bridge-fd 0
    bridge-vlan-aware yes
    bridge-vids 10 20 30
```

> ⚠️ Adapter `eno1` au nom réel de votre interface (`ip link` pour vérifier).

```bash
systemctl restart networking
```

## Étape 3 — Créer la VM pfSense

| Paramètre | Valeur |
|:----------|:-------|
| OS | FreeBSD 14 / pfSense CE 24.0 |
| RAM | 2 Go |
| Disque | 16 Go |
| NIC 1 (WAN) | `vmbr0` **sans VLAN tag** (accès Internet natif) |
| NIC 2 (LAN) | `vmbr0` **VLAN tag 10** |

> En LAB, les deux NIC de pfSense sont sur le même bridge `vmbr0`.
> NIC 1 (WAN) récupère une IP via DHCP depuis votre box/routeur.
> NIC 2 (LAN) sera l'interface trunk pour les VLANs internes.

## Étape 4 — Configurer pfSense

Suivre le [runbook §4.2](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#42-pfsense) normalement :

1. Assigner `em0` = WAN, `em1` = LAN
2. Créer les sous-interfaces VLAN 10, 20, 30 sur `em1`
3. Configurer DHCP, DNS, règles FW

## Étape 5 — Créer les VMs

Créer les VMs directement sur le stockage local de PVE :

```bash
# Télécharger les ISOs
cd /var/lib/vz/template/iso/
# Debian 12 (Bookworm) — pour PBS, MON-01, stack web, Mailcow
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso

# pfSense — déjà installé à l'étape 3, mais garder l'ISO pour référence
# Télécharger depuis https://www.pfsense.org/download/
```

Chaque VM utilise `vmbr0` avec le **VLAN tag** correspondant :

| VM | VLAN tag | IP |
|:---|:--------:|:---|
| AD-DC01 | 10 | 192.168.10.10 |
| FS01 | 10 | 192.168.10.111 |
| MAIL-01 | 10 | 192.168.10.115 |
| MON-01 | 10 | 192.168.10.114 |
| PBS | 30 | 192.168.30.100 |
| rp-prod01 | 20 | 192.168.20.106 |
| web-wp01 | 20 | 192.168.20.108 |
| maria-prod01 | 20 | 192.168.20.105 |

## Configuration avec 16 Go de RAM

Si vous n'avez que 16 Go de RAM, réduisez les allocations :

| VM | RAM normale | RAM réduite | Notes |
|:---|:----------:|:----------:|:------|
| pfSense | 2 Go | 1 Go | Suffisant pour < 20 VMs |
| AD-DC01 | 4 Go | 2 Go | 2 Go minimum pour Samba AD |
| AD-DC02 | 4 Go | **Supprimer** | Pas critique en LAB |
| FS01 | 4 Go | 2 Go | 2 Go suffisent pour SMB |
| MAIL-01 | 6 Go | 4 Go | Mailcow = 4 Go **minimum** |
| MON-01 | 4 Go | 2 Go | Checkmk Raw suffisant |
| PBS | 2 Go | 1 Go | Processus léger |
| maria-prod01 | 2 Go | 1 Go | Base WP petite |
| web-wp01 | 2 Go | 1 Go | Apache + PHP |
| rp-prod01 | 1 Go | 512 Mo | NGINX = très léger |
| **Total** | **~27 Go** | **~14,5 Go** | ✅ Rentre dans 16 Go |

> ⚠️ Démarrer les VMs **par groupe** : d'abord pfSense + DC01, puis les services, enfin la stack web.

## Validation

```bash
# Depuis pfSense (ou une VM VLAN 10)
ping 192.168.10.10    # AD-DC01
ping 192.168.20.106   # rp-prod01 (inter-VLAN)
ping 192.168.30.100   # PBS (inter-VLAN)
ping 8.8.8.8          # Internet
```

## Ensuite

➡️ Suivre le [runbook J0](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md) à partir de **§4.4** (Samba AD).
Ignorer §4.1 (Switch), §4.3 (Cluster).
