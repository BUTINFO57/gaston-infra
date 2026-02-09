# 🔧 Dépannage rapide

## Table de diagnostic

| Symptôme | Cause probable | Vérification | Correction |
|:---------|:---------------|:-------------|:-----------|
| Pas d'IP DHCP | DHCP non activé | `Services > DHCP Server` | Activer + configurer plage |
| Pas de ping inter-VLAN | Règle FW manquante ou trunk mal configuré | `Firewall > Rules` | Ajouter règle PASS |
| DNS gaston.local échoue | Domain Override manquant | `Services > DNS Resolver > Domain Overrides` | Ajouter gaston.local → DC01/DC02 |
| VM ne démarre pas | Stockage ha-nfs déconnecté | `pvesm status` | `exportfs -ra` + restart NFS sur PVE03 |
| Quorum perdu | < 2 nœuds en ligne | `pvecm status` | Remettre nœud en ligne ou `pvecm expected 1` |
| AD-DC01 ne répond pas | Service samba-ad-dc arrêté | `systemctl status samba-ad-dc` | `systemctl restart samba-ad-dc` |
| FS01 inaccessible | Relation domaine cassée | `Test-ComputerSecureChannel` | `Reset-ComputerMachinePassword` |
| Mailcow containers down | Docker crash | `docker compose ps` | `docker compose up -d` |
| Site web 502 | Apache arrêté sur web-wp01 | `systemctl status apache2` | `systemctl restart apache2` |
| /wp-admin 403 depuis ADMIN | IP source pas dans allow NGINX | `/etc/nginx/sites-available/gaston` | Ajouter IP/réseau dans `allow` |
| PBS backup échoue | Port 8007 bloqué 10→30 | FW rules pfSense | Règle PASS vers HOST_PBS:8007 |
| Checkmk agent unreachable | Port 6556 bloqué | `ufw status` + FW pfSense | Ouvrir 6556/TCP |
| VPN ne se connecte pas | CA expiré ou LDAP unreachable | `Status > OpenVPN` | Vérifier LDAP + certificats |

## Commandes de diagnostic essentielles

### Proxmox

```bash
pvecm status                          # Cluster status
qm list                              # Lister les VMs
ha-manager status                     # HA status
pvesm status                         # Stockage
journalctl -u pve-cluster -f         # Logs cluster
```

### Samba AD

```bash
kinit Administrator && klist
samba-tool domain info 127.0.0.1
samba-tool fsmo show
samba-tool drs showrepl               # Réplication
systemctl status samba-ad-dc
```

### Windows Server Core (FS01)

```powershell
Get-ComputerInfo | Select CsDomain, CsName
Test-ComputerSecureChannel -Verbose
Get-SmbShare
Get-SmbShareAccess -Name "Production"
```

### Mailcow

```bash
cd /opt/mailcow-dockerized
docker compose ps
docker compose logs -f postfix-mailcow
```

### Checkmk

```bash
omd status gaston
omd restart gaston
cmk -d <hostname>
```

### PBS

```bash
proxmox-backup-manager datastore list
proxmox-backup-manager datastore status backup-main
df -h /mnt/datastore/backup-main/
```

### Réseau

```bash
# pfSense — depuis le shell
pfctl -sr                             # Règles PF actives
pfctl -si                             # Stats interfaces
cat /tmp/dhcpd.leases                 # Baux DHCP
```
