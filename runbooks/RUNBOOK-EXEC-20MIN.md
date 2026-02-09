# ⚡ RUNBOOK EXÉCUTIF — Checklist 20 minutes

> Version condensée du [runbook complet](RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md).
> À utiliser "sur le terrain" pour vérifier l'avancement sans relire les 2000+ lignes.

---

## 08:00–09:00 — FONDATIONS

```text
[ ] Switch SG350 : VLANs 10/20/30 créés
[ ] Switch : trunks Gi1-Gi4 configurés (native VLAN 10)
[ ] Switch : ports inutilisés désactivés
[ ] Switch : mgmt IP 192.168.10.2
[ ] Proxmox VE 9 : Install PVE1 (.11), PVE2 (.12), PVE03 (.50)
[ ] pfSense CE 24 : Install, WAN em0 DHCP, LAN em1 .10.1/24
```

## 09:00–10:30 — RÉSEAU

```text
[ ] pfSense : VLAN 20 (.20.1/24), VLAN 30 (.30.1/24)
[ ] pfSense : DHCP x3 VLANs (range .100-.200, DNS→.10.10/.10.9)
[ ] pfSense : DNS Resolver + Domain Override gaston.local→.10.10,.10.9
[ ] pfSense : Aliases (réseaux, hôtes, ports)
[ ] pfSense : Règles FW deny-default par VLAN
[ ] pfSense : NAT Outbound automatique
[ ] pfSense : VPN OpenVPN (CA, cert, LDAP, serveur, rules, export)
```

## 10:00–11:30 — CLUSTER

```text
[ ] Bridges VLAN-aware sur chaque nœud PVE (/etc/network/interfaces)
[ ] pvecm create gaston-cluster (sur PVE1)
[ ] pvecm add 192.168.10.11 (sur PVE2)
[ ] pvecm add 192.168.10.11 (sur PVE03)
[ ] NFS : /srv/nfs/ha sur PVE03 (apt install nfs-kernel-server)
[ ] NFS : export /srv/nfs/ha → 192.168.10.0/24
[ ] PVE WebUI : Storage > Add > NFS → ha-nfs
```

## ⚡ 12:00 — GO/NO-GO

```text
[ ] pvecm status → Quorate: Yes, Total Votes: 3
[ ] ping 192.168.20.1 depuis VLAN 10 → OK
[ ] ping 8.8.8.8 depuis VLAN 10 → OK
[ ] nslookup google.com 192.168.10.1 → résolu
[ ] pvesm status → ha-nfs actif
[ ] pfSense XML exporté
```

> 🔴 Si un critère échoue → STOP. Corriger avant de continuer.

## 12:15–13:30 — IDENTITÉ

```text
[ ] VM AD-DC01 : Debian 13, .10.10, 2vCPU/4Go/32Go, VLAN 10
[ ] samba-tool domain provision --realm=GASTON.LOCAL
[ ] kinit Administrator → ticket OK
[ ] samba-tool fsmo show → 5/5 roles sur DC01
[ ] Structure OU : _Tier-0, _Tier-1, _Tier-2, Disabled
[ ] Groupes : 7 métier + 8 ACL + 2 admin + imbrication AGDLP
[ ] Comptes service : svc-ldap-pfsense, svc-ldap-bind, svc-backup, svc-monitoring
[ ] DNS : 15+ records A/MX/SPF/DMARC/CNAME
[ ] VM AD-DC02 : Debian 13, .10.9, domain join → réplica
[ ] samba-tool drs showrepl → "was successful"
```

## 13:30–14:00 — SERVEUR FICHIERS

```text
[ ] VM FS01 : Win 2022 Core, .10.111, 2vCPU/4Go, VLAN 10
[ ] Join domaine gaston.local
[ ] Disque DATA (D:) initialisé GPT/NTFS/200 Go
[ ] 7 partages SMB créés avec ABE
[ ] Permissions NTFS AGDLP appliquées
[ ] SMBv1 désactivé
[ ] Logon script dans SYSVOL
```

## 14:00–14:45 — MESSAGERIE

```text
[ ] VM MAIL-01 : Debian 13, .10.115, 4vCPU/6-8Go, VLAN 10
[ ] Docker + docker-compose-plugin installés
[ ] Mailcow cloné dans /opt/mailcow-dockerized
[ ] generate_config.sh → mail.gaston.local
[ ] docker compose up -d → 15 containers Up
[ ] WebUI https://192.168.10.115 accessible
```

## 14:45–15:15 — MONITORING

```text
[ ] VM MON-01 : Debian 13, .10.114, 2vCPU/4Go, VLAN 10
[ ] Checkmk Raw 2.4 installé (.deb)
[ ] omd create gaston + omd start gaston
[ ] cmk-passwd cmkadmin → mot de passe défini
[ ] Agents déployés sur toutes les VMs Linux (.deb + register)
[ ] Agent Windows déployé sur FS01 (.msi)
[ ] 12 hôtes ajoutés + Activate Changes
```

## 15:15–16:00 — SAUVEGARDE

```text
[ ] VM PBS : Debian 12, .30.100, 2-4vCPU/4-8Go, VLAN 30
[ ] PBS installé (pbs-no-subscription repo)
[ ] Datastore backup-main créé (200 Go ext4)
[ ] User backup@pbs créé avec rôle DatastoreBackup
[ ] PVE : Storage > Add > PBS → intégré
[ ] Job backup-prod : 08:00, 4 VMs, 90 jours
[ ] Job backup-infra : 21:00, 5 VMs, 90 jours
[ ] 1 backup manuel lancé → completed
[ ] 1 restore testé → VM démarre
```

## 16:00–17:00 — PRODUCTION WEB

```text
[ ] VM maria-prod01 : Debian 12, .20.105, VLAN 20
[ ] MariaDB installé, base wordpress_db créée, user wp_user
[ ] bind-address = 192.168.20.105
[ ] UFW : deny default + allow 3306 from .20.108

[ ] VM web-wp01 : Debian 12, .20.108, VLAN 20
[ ] Apache + PHP 8.2+ + WordPress installés
[ ] wp-config.php : DB_HOST=192.168.20.105
[ ] UFW + Fail2ban actifs

[ ] VM rp-prod01 : Debian 12, .20.106, VLAN 20
[ ] NGINX + cert auto-signé
[ ] vhost : TLS termination + proxy_pass → .20.108:80
[ ] /wp-admin : allow 192.168.10.0/24 + 10.99.0.0/24, deny all
[ ] UFW + Fail2ban actifs

[ ] SSH hardening sur les 3 VMs : PasswordAuth=no, RootLogin=no
[ ] HA Manager : 8 VMs ajoutées (5 ha-infra + 3 ha-prod)
```

## 17:00–18:00 — SÉCURITÉ + RECETTE

```text
[ ] Tous les mots de passe par défaut changés
[ ] Comptes de service AD : MDP ≥ 20 chars
[ ] pfSense WebUI : HTTPS only
[ ] LDAPS (636) pour auth VPN
[ ] Export config pfSense XML
[ ] Switch : Copy Running → Startup
[ ] Snapshots VMs critiques post-deploy
[ ] Fail2ban actif sur web VMs
[ ] Logging FW activé (WAN BLOCK min)
```

## ✅ 18:00 — MVP OPÉRATIONNEL

```text
[ ] Quorum PVE 3/3
[ ] 8 VMs HA
[ ] 12 hôtes supervisés Checkmk
[ ] 9 VMs sauvegardées PBS
[ ] Site HTTPS accessible
[ ] AD + DNS + DHCP fonctionnels
[ ] VPN opérationnel
```
