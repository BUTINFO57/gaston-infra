# Référence réseau — Exemple

Ce fichier résume l'architecture réseau. Copier et adapter pour votre environnement.

## VLANs

| VLAN ID | Nom | Sous-réseau | Passerelle | Usage |
|:-------:|:-----|:-------|:--------|:--------|
| 10 | Admin/Infra | 192.168.10.0/24 | 192.168.10.1 | AD, FS, Mail, Mon, GLPI |
| 20 | Production | 192.168.20.0/24 | 192.168.20.1 | Web 3-tiers |
| 30 | Sauvegarde | 192.168.30.0/24 | 192.168.30.1 | PBS |
| 99 | WAN | DHCP | — | Liaison Internet |

## Plages DHCP (pfSense)

| VLAN | Plage | Portée |
|:----:|:------|:------|
| 10 | 192.168.10.150 – 192.168.10.200 | Postes de travail |
| 20 | 192.168.20.150 – 192.168.20.200 | Périphériques |

## DNS

| Serveur | IP | Rôle |
|:-------|:---|:-----|
| AD-DC01 | 192.168.10.10 | DNS Primaire (interne Samba) |
| AD-DC02 | 192.168.10.9 | DNS Secondaire |
| pfSense | Redirecteur | Redirige vers AD-DC01/DC02 |

## VPN

| Paramètre | Valeur |
|:----------|:------|
| Protocole | UDP |
| Port | 1194 |
| Tunnel | 10.99.0.0/24 |
| Auth | LDAP (AD) |
| Routes poussées | 192.168.10.0/24, 192.168.20.0/24, 192.168.30.0/24 |

## Switch — Cisco SG350-28

| Port | Mode | VLAN(s) | Connecté à |
|:-----|:-----|:--------|:-------------|
| gi1 | Trunk | 10,20,30,99 | pfSense |
| gi2 | Trunk | 10,20,30 | PVE1 |
| gi3 | Trunk | 10,20,30 | PVE2 |
| gi4 | Trunk | 10,20,30 | PVE3 |
| gi5-gi24 | Access | 10 | Postes de travail |
| gi25-gi26 | Trunk | 10,20,30 | LAG (si nécessaire) |
