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

3. Post-install — désactiver le repo enterprise :

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
wget <URL_DEBIAN_12_ISO>
wget <URL_DEBIAN_13_ISO>
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
