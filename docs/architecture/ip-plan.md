# 🗺️ Plan IP / VLAN Complet

## VLANs

| VLAN | ID | Réseau | Passerelle | DHCP Range | DNS | Domain |
|:-----|:--:|:-------|:-----------|:-----------|:----|:-------|
| Admin/Infra | 10 | `192.168.10.0/24` | `.10.1` | `.100–.200` | `.10.10`, `.10.9` | `gaston.local` |
| Production | 20 | `192.168.20.0/24` | `.20.1` | `.100–.200` | `.10.10`, `.10.9` | `gaston.local` |
| Backup | 30 | `192.168.30.0/24` | `.30.1` | `.100–.200` | `.10.10`, `.10.9` | `gaston.local` |
| VPN | — | `10.99.0.0/24` | `10.99.0.1` | Dynamique | `.10.10`, `.10.9` | `gaston.local` |
| WAN | 99 | DHCP (FAI) | — | — | FAI | — |

## Adresses IP statiques

| Hostname | FQDN | IP | VLAN | OS | Rôle | HA |
|:---------|:-----|:---|:----:|:---|:-----|:--:|
| pfSense | pfsense.gaston.local | `.10.1` / `.20.1` / `.30.1` | * | FreeBSD 14.0 | FW / Routeur / VPN / DHCP / DNS | — |
| SG350-28 | — | `.10.2` | 10 | Cisco IOS | Switch L2 802.1Q | — |
| AD-DC02 | ad-dc02.gaston.local | `.10.9` | 10 | Debian 13 | Samba AD Replica | ✅ |
| AD-DC01 | ad-dc01.gaston.local | `.10.10` | 10 | Debian 13 | Samba AD Primary (FSMO 5/5) | ✅ |
| PVE1 | pve1.gaston.local | `.10.11` | 10 | PVE 9.0 | Hyperviseur PRODUCTION | — |
| PVE2 | pve2.gaston.local | `.10.12` | 10 | PVE 9.0 | Hyperviseur INFRASTRUCTURE | — |
| PVE03 | pve03.gaston.local | `.10.50` | 10 | PVE 9.0 | Hyperviseur Secours + NFS | — |
| FS01 | fs01.gaston.local | `.10.111` | 10 | Win Server 2022 Core | File Server SMB 3.1.1 | ✅ |
| PBS | pbs.gaston.local | `.30.100` | 30 | Debian 12 | Proxmox Backup Server v3 | — |
| MON-01 | mon-01.gaston.local | `.10.114` | 10 | Debian 13 | Checkmk Raw 2.4 | ✅ |
| MAIL-01 | mail-01.gaston.local | `.10.115` | 10 | Debian 13 | Mailcow Dockerized | ✅ |
| GLPI | glpi.gaston.local | `.10.122` | 10 | Debian 12 | ITSM / Ticketing | — |
| maria-prod01 | maria-prod01.gaston.local | `.20.105` | 20 | Debian 12 | MariaDB 10.x | ✅ |
| rp-prod01 | rp-prod01.gaston.local | `.20.106` | 20 | Debian 12 | NGINX Reverse Proxy | ✅ |
| web-wp01 | web-wp01.gaston.local | `.20.108` | 20 | Debian 12 | WordPress 6.x / Apache 2.4 / PHP 8.2+ | ✅ |

> **Décision :** IPs VLAN 20 = `.105` / `.106` / `.108` (alignées sur les règles pfSense en place) comme référence autoritaire.
> **Décision :** GLPI = Debian 12 + GLPI 9.5 (confirmé par les rapports projet).
> **Décision :** PBS = 1 NIC sur VLAN 30 (`192.168.30.100`). Le monitoring passe par le routage pfSense VLAN 30 → VLAN 10.

## Ports trunk Switch SG350-28

| Port | Mode | Connecté à | VLANs |
|:-----|:-----|:-----------|:------|
| Gi1 | Trunk | pfSense (em1) | 10 (native), 20, 30 |
| Gi2 | Trunk | PVE1 | 10, 20, 30 |
| Gi3 | Trunk | PVE2 | 10, 20, 30 |
| Gi4 | Trunk | PVE03 | 10, 20, 30 |
| Gi5–20 | Access | Postes clients | 10 ou 20 |
| Gi21–28 | Shutdown | Réservés | — |

## WebUI Quick Reference

| Service | URL | Port |
|:--------|:----|:----:|
| Proxmox PVE1 | `https://192.168.10.11:8006` | 8006 |
| Proxmox PVE2 | `https://192.168.10.12:8006` | 8006 |
| Proxmox PVE03 | `https://192.168.10.50:8006` | 8006 |
| PBS | `https://192.168.30.100:8007` | 8007 |
| pfSense | `https://192.168.10.1` | 443 |
| Checkmk | `https://192.168.10.114/gaston` | 443 |
| Mailcow | `https://192.168.10.115` | 443 |
| SOGo Webmail | `https://192.168.10.115/SOGo` | 443 |
| Switch | `https://192.168.10.2` | 443 |
