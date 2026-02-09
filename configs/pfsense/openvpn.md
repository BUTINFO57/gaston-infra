# pfSense — Configuration OpenVPN

## PKI

| Élément | Chemin | Valeur |
|:-----|:-----|:------|
| AC | `System > Cert Manager > CAs` | Créer une AC interne `Gaston-CA` |
| Certificat serveur | `System > Cert Manager > Certificates` | Créer le certificat `pfSense-VPN` signé par `Gaston-CA` |

## Serveur d'authentification LDAP

`System > User Manager > Authentication Servers`

| Paramètre | Valeur |
|:----------|:------|
| Type | LDAP |
| Hostname | `ad-dc01.gaston.local` |
| Port | 636 (LDAPS) |
| Transport | SSL/TLS |
| Base DN | `DC=gaston,DC=local` |
| Auth Container | `OU=Users,OU=_Tier-2,DC=gaston,DC=local` |
| Extended Query | `memberOf=CN=ACL_VPN_RemoteUsers,CN=Users,DC=gaston,DC=local` |
| Bind DN | `CN=svc-ldap-pfsense,OU=ServiceAccounts,OU=Admins,OU=_Tier-0,DC=gaston,DC=local` |
| Bind Password | `<PLACEHOLDER>` |
| User Attribute | `sAMAccountName` |

> **Décision** : Auth Container = `OU=Users,OU=_Tier-2,DC=gaston,DC=local` — les utilisateurs VPN sont dans le Tier-2 de la structure AD.

## Serveur OpenVPN

`VPN > OpenVPN > Servers`

| Paramètre | Valeur |
|:----------|:------|
| Mode | Remote Access (LDAP) |
| Protocol | UDP / IPv4 |
| Port | 1194 |
| Tunnel Network | 10.99.0.0/24 |
| Topology | subnet |
| Local Networks | 192.168.10.0/24, 192.168.20.0/24, 192.168.30.0/24 |
| Data Ciphers | AES-256-GCM, CHACHA20-POLY1305 |
| Fallback Cipher | AES-256-CBC |
| Auth Digest | SHA256 |
| DNS Server 1 | 192.168.10.10 |
| DNS Server 2 | 192.168.10.9 |
| Default Domain | gaston.local |
| TLS Auth | Enabled |
| Compression | Disabled |

## Export client

1. Installer le paquet `openvpn-client-export` via `System > Package Manager`
2. Télécharger le profil `.ovpn` depuis `VPN > OpenVPN > Client Export`
