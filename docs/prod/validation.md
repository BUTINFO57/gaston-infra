# 🏭 PROD — Tests de Validation

Checklist de tests à exécuter **après** le déploiement J0.
Chaque bloc correspond à une section du [runbook](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md).

## Réseau & Sécurité

- [ ] Switch SG350 : VLANs 10, 20, 30 créés, trunks Gi1–Gi4 actifs
- [ ] pfSense : interfaces VLAN assignées et opérationnelles
- [ ] pfSense : deny-by-default vérifié (flux non autorisé → BLOCK)
- [ ] pfSense : NAT sortant fonctionnel (Internet depuis tous les VLANs)
- [ ] pfSense : VPN OpenVPN établi avec auth LDAP/AD
- [ ] DHCP : bons paramètres par VLAN (DNS, GW, domain)

### Tests réseau

```bash
# Depuis VLAN 10
ping 192.168.20.1     # Passerelle VLAN 20
ping 192.168.30.1     # Passerelle VLAN 30
ping 8.8.8.8          # Internet
nslookup google.com 192.168.10.1  # DNS Resolver

# Test deny-by-default : tenter un flux interdit
# Depuis VLAN 20, ping vers VLAN 30 (devrait échouer si pas de règle)
```

## Identité & Accès

- [ ] AD-DC01 opérationnel, 5 FSMO roles
- [ ] AD-DC02 répliqué
- [ ] Structure OU Tier-0/1/2 créée
- [ ] Groupes métier + ACL imbriqués
- [ ] Comptes de service créés
- [ ] Au moins 2 utilisateurs test authentifiés

### Tests AD

```bash
# Sur AD-DC01
kinit Administrator && klist
samba-tool domain info 127.0.0.1
samba-tool fsmo show                # 5/5 rôles
host -t SRV _ldap._tcp.gaston.local 127.0.0.1

# Sur AD-DC02
samba-tool drs showrepl             # "was successful"
nslookup pve1.gaston.local 192.168.10.9

# Test utilisateur
kinit gaston.leger
```

## Services

- [ ] FS01 joint au domaine, 7 partages SMB, RBAC NTFS + SMB
- [ ] MAIL-01 : 15 containers Mailcow running, webmail accessible
- [ ] MON-01 : 12 hôtes supervisés, tous UP

### Tests services

```powershell
# Sur FS01
Test-ComputerSecureChannel -Verbose    # True
Get-SmbShare                           # 7 partages
Get-SmbServerConfiguration | Select EnableSMB1Protocol  # False
```

```bash
# Sur MAIL-01
cd /opt/mailcow-dockerized && docker compose ps  # 15 Up

# Vérifier DNS
nslookup -type=mx gaston.local 192.168.10.10
```

## Sauvegarde

- [ ] PBS : datastore `backup-main` opérationnel
- [ ] PBS intégré dans PVE
- [ ] 1 backup exécuté avec succès
- [ ] 1 restore testé avec succès

```bash
# Sur PBS
proxmox-backup-manager datastore list
proxmox-backup-manager datastore status backup-main
```

## Production Web

- [ ] Site HTTPS accessible (HTTP 200)
- [ ] `/wp-admin` accessible uniquement depuis VLAN 10 et VPN
- [ ] MariaDB accessible uniquement depuis web-wp01
- [ ] UFW + Fail2ban actifs
- [ ] SSH clé-only, root login désactivé

```bash
# Depuis VLAN 10
curl -kI https://192.168.20.106           # 200
curl -kI https://192.168.20.106/wp-admin  # 302 (redirect login)

# Depuis VLAN 20 (autre machine)
curl -kI https://192.168.20.106/wp-admin  # 403

# Base de données
mysql -h 192.168.20.105 -u wp_user -p wordpress_db  # depuis web-wp01 OK
```

## Haute Disponibilité

- [ ] Quorum Proxmox : 3/3 nœuds
- [ ] 8 VMs en HA Manager
- [ ] Stockage ha-nfs accessible depuis les 3 nœuds

```bash
pvecm status          # Quorate: Yes, 3/3
ha-manager status     # 8 VMs listées
pvesm status          # ha-nfs actif sur 3 nœuds
```
