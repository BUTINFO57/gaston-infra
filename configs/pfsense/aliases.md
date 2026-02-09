# pfSense — Alias

## Alias réseau

| Nom | Type | Valeur | Description |
|:-----|:-----|:------|:------------|
| NET_LAN_ADMIN | Réseau | 192.168.10.0/24 | VLAN 10 — Admin/Infra |
| NET_PROD | Réseau | 192.168.20.0/24 | VLAN 20 — Production |
| NET_BACKUP | Réseau | 192.168.30.0/24 | VLAN 30 — Sauvegarde |
| NET_VPN | Réseau | 10.99.0.0/24 | Tunnel OpenVPN |

## Alias hôtes

| Nom | Type | Valeur | Description |
|:-----|:-----|:------|:------------|
| HOST_ADDC01 | Hôte | 192.168.10.10 | AD-DC01 Primaire |
| HOST_ADDC02 | Hôte | 192.168.10.9 | AD-DC02 Réplica |
| HOST_FS01 | Hôte | 192.168.10.111 | Serveur de fichiers |
| HOST_MAIL | Hôte | 192.168.10.115 | Mailcow |
| HOST_MON | Hôte | 192.168.10.114 | Checkmk |
| HOST_PBS | Hôte | 192.168.30.100 | Proxmox Backup |
| HOST_RP | Hôte | 192.168.20.106 | NGINX RP |
| HOST_WP | Hôte | 192.168.20.108 | WordPress |
| HOST_DB | Hôte | 192.168.20.105 | MariaDB |
| HOST_GLPI | Hôte | 192.168.10.122 | GLPI |

## Alias de ports

| Nom | Type | Valeur | Description |
|:-----|:-----|:------|:------------|
| PORTS_AD_CORE | Port | 88, 135, 389, 445, 464, 636, 3268 | Ports cœur AD |
| PORTS_MAIL | Port | 25, 587, 993 | Ports messagerie |
| PORTS_WEB | Port | 80, 443 | HTTP/HTTPS |

## Comment configurer

`Firewall > Aliases > IP` et `Firewall > Aliases > Ports`

Créer chaque alias avec le nom, le type et la valeur listés ci-dessus.
Utiliser des alias dans les règles de pare-feu les rend lisibles et maintenables.
