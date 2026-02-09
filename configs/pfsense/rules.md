# pfSense — Règles de pare-feu

## Politique : Deny-by-Default (Zero Trust)

Toutes les interfaces ont un BLOCK ALL implicite à la fin.
Seul le trafic explicitement autorisé passe.

## Règles WAN

| # | Action | Source | Dest | Port | Proto | Description |
|:-:|:-------|:-------|:-----|:-----|:------|:-----------|
| 1 | PASS | Any | Adresse WAN | 1194 | UDP | OpenVPN |
| 2 | BLOCK | RFC1918 | Any | * | * | Bloquer réseaux privés (anti-usurpation) |
| 3 | BLOCK | Bogon | Any | * | * | Bloquer réseaux bogon |

## Règles LAN (VLAN 10 — Admin)

| # | Action | Source | Dest | Port | Proto | Description |
|:-:|:-------|:-------|:-----|:-----|:------|:------------|
| 1 | PASS | NET_LAN_ADMIN | Any | 80, 443 | TCP | Admin → Internet |
| 2 | PASS | NET_LAN_ADMIN | NET_PROD | 80, 443, 3389 | TCP | Admin → PROD (Web + RDP) |
| 3 | PASS | NET_LAN_ADMIN | HOST_PBS | 8007 | TCP | Admin → PBS |
| 4 | PASS | NET_LAN_ADMIN | HOST_ADDC01, HOST_ADDC02 | 53 | UDP | Admin → DNS |
| 5 | PASS | NET_LAN_ADMIN | HOST_ADDC01, HOST_ADDC02 | PORTS_AD_CORE | TCP/UDP | Admin → AD |
| 6 | PASS | NET_LAN_ADMIN | HOST_MAIL | 587, 993 | TCP | Admin → Mail |
| 7 | PASS | NET_LAN_ADMIN | HOST_FS01 | 445 | TCP | Admin → SMB |

## Règles PROD (VLAN 20)

| # | Action | Source | Dest | Port | Proto | Description |
|:-:|:-------|:-------|:-----|:-----|:------|:------------|
| 1 | PASS | NET_PROD | Any | 80, 443 | TCP | PROD → Internet |
| 2 | PASS | NET_PROD | HOST_ADDC01, HOST_ADDC02 | 53 | UDP | PROD → AD DNS |
| 3 | PASS | NET_PROD | HOST_ADDC01, HOST_ADDC02 | PORTS_AD_CORE | TCP/UDP | PROD → AD Core |
| 4 | PASS | NET_PROD | HOST_ADDC01, HOST_ADDC02 | 49152-65535 | TCP | PROD → AD RPC Dynamic |
| 5 | PASS | NET_PROD | HOST_MAIL | 587, 993 | TCP | PROD → Mail |
| 6 | PASS | NET_PROD | HOST_FS01 | 445 | TCP | PROD → SMB |

## Règles SAUVEGARDE (VLAN 30)

| # | Action | Source | Dest | Port | Proto | Description |
|:-:|:-------|:-------|:-----|:-----|:------|:------------|
| 1 | PASS | HOST_PBS | HOST_ADDC01, HOST_ADDC02 | 53 | UDP | PBS → DNS |
| 2 | PASS | HOST_PBS | Any | 80, 443 | TCP | PBS → Internet (updates) |

## Règles OpenVPN

| # | Action | Source | Dest | Port | Proto | Description |
|:-:|:-------|:-------|:-----|:-----|:------|:------------|
| 1 | PASS | NET_VPN | HOST_ADDC01, HOST_ADDC02 | 53 | UDP | VPN → DNS |
| 2 | PASS | NET_VPN | NET_PROD | 80, 443 | TCP | VPN → Web |
| 3 | PASS | NET_VPN | NET_PROD | 3389 | TCP | VPN → RDP |
| 4 | PASS | NET_VPN | HOST_FS01 | 445 | TCP | VPN → SMB |
| 5 | PASS | NET_VPN | HOST_MAIL | 587, 993 | TCP | VPN → Mail |
| 6 | PASS | NET_VPN | HOST_PBS | 8007 | TCP | VPN → PBS |
| 7 | PASS | NET_VPN | HOST_GLPI | 80, 443 | TCP | VPN → GLPI |
| 8 | PASS | NET_VPN | NET_LAN_ADMIN | 3389 | TCP | VPN → RDP Admin |
