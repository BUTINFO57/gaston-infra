# 🔀 Matrice des Flux

## Flux réseau autorisés

| # | Source | Destination | Port(s) | Proto | Description |
|:-:|:-------|:------------|:--------|:------|:------------|
| 1 | Any (WAN) | pfSense WAN | 1194 | UDP | OpenVPN |
| 2 | VLAN 10 | VLAN 20 | 80, 443 | TCP | Admin → Web |
| 3 | VLAN 10 | VLAN 20 | 3389 | TCP | Admin → RDP |
| 4 | VLAN 10 | PBS (.30.100) | 8007 | TCP | Admin → PBS |
| 5 | VLAN 10 | Internet | 80, 443 | TCP | Admin → Internet |
| 6 | VLAN 20 | AD-DC01/DC02 | 53, 88, 389, 445, 636 | TCP/UDP | PROD → AD Core |
| 7 | VLAN 20 | AD-DC01/DC02 | 49152-65535 | TCP | PROD → AD RPC Dynamic |
| 8 | VLAN 20 | MAIL-01 | 587, 993 | TCP | PROD → Mail |
| 9 | VLAN 20 | FS01 | 445 | TCP | PROD → SMB |
| 10 | VLAN 20 | Internet | 80, 443 | TCP | PROD → Internet |
| 11 | PBS (.30.100) | AD-DC01/DC02 | 53 | UDP | PBS → DNS |
| 12 | PBS (.30.100) | Internet | 80, 443 | TCP | PBS → Mises à jour |
| 13 | MON-01 | pfSense | 161 | UDP | SNMP monitoring |
| 14 | MON-01 | VLAN 20 | 6556, ICMP | TCP | Checkmk agents PROD |
| 15 | MON-01 | PBS | 6556, ICMP | TCP | Checkmk PBS |
| 16 | VPN (10.99.0.0/24) | Multi | Multi | TCP | Remote access |
| 17 | rp-prod01 | web-wp01 | 80 | TCP | NGINX → WordPress |
| 18 | web-wp01 | maria-prod01 | 3306 | TCP | WordPress → MariaDB |
| 19 | PVE (all) | PVE (all) | 5405-5412 | UDP | Corosync |
| 20 | PVE (all) | PBS | 8007 | TCP | Backup jobs |
| 21 | PVE (all) | PVE03 NFS | 2049 | TCP | NFS mount |

## Principes

- **Deny-by-default** : tout flux non listé ci-dessus est bloqué par pfSense
- **Zero Trust** : chaque VLAN est considéré comme potentiellement hostile
- **Least Privilege** : seuls les ports nécessaires sont ouverts
- **Logs** : les flux bloqués sont journalisés sur pfSense (WAN BLOCK minimum)

## Ports critiques par service

| Port | Proto | Service | Utilisé par |
|:-----|:------|:--------|:------------|
| 22 | TCP | SSH | Admin → toutes les VMs Linux |
| 53 | UDP/TCP | DNS | AD-DC01, AD-DC02 (Samba Internal) |
| 80/443 | TCP | HTTP/HTTPS | Site web, WebUI services |
| 88 | UDP/TCP | Kerberos | AD authentication |
| 161 | UDP | SNMP | Checkmk → pfSense |
| 389/636 | TCP | LDAP/LDAPS | AD, pfSense VPN auth |
| 445 | TCP | SMB | FS01 partages fichiers |
| 587/993 | TCP | SMTP/IMAP | Mailcow |
| 1194 | UDP | OpenVPN | VPN accès distant |
| 2049 | TCP | NFS | PVE03 stockage partagé |
| 3306 | TCP | MariaDB | web-wp01 → maria-prod01 |
| 5405-5412 | UDP | Corosync | Cluster Proxmox |
| 6556 | TCP | Checkmk Agent | Monitoring (TLS) |
| 8006 | TCP | Proxmox VE WebUI | Administration cluster |
| 8007 | TCP | PBS WebUI/API | Sauvegarde |
