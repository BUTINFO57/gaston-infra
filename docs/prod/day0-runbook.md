# 🏭 PROD — Runbook J0 (Guide de déploiement)

Ce document est le point d'entrée pour le déploiement production.
Il renvoie vers le [runbook complet](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md) pour chaque étape.

## Pré-requis

- [ ] Matériel installé et câblé (voir [overview.md](overview.md))
- [ ] ISOs gravés / sur clés USB
- [ ] Mots de passe générés et stockés dans un gestionnaire sécurisé
- [ ] Plan IP imprimé (voir [IP plan](../architecture/ip-plan.md))
- [ ] Ce document imprimé ou sur tablette

## Déroulé

### 08:00 — Fondations réseau

| Étape | Runbook | Validation |
|:------|:--------|:-----------|
| Switch SG350 : VLANs + trunks | [§4.1](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#41-switch-cisco-sg350-28) | `show vlan` → VLANs 10/20/30 |
| pfSense : install + WAN/LAN | [§4.2.1–4.2.3](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#421-installation) | WebUI `https://192.168.10.1` |
| pfSense : DHCP + DNS | [§4.2.4–4.2.5](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#424-dhcp) | DHCP lease + `nslookup` OK |
| pfSense : FW rules + NAT | [§4.2.6–4.2.7](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#426-règles-firewall) | Ping inter-VLAN + Internet |
| pfSense : VPN OpenVPN | [§4.2.8](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#428-vpn-openvpn-30-min) | VPN connect + IP 10.99.0.x |

### 10:00 — Cluster Proxmox

| Étape | Runbook | Validation |
|:------|:--------|:-----------|
| Install PVE ×3 | [§4.3.1](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#431-installation-en-parallèle-sur-3-serveurs) | WebUI sur chaque nœud |
| Bridges VLAN | [§4.3.2](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#432-réseau-vlan-bridges) | `ip link` → vmbr0 up |
| Créer cluster | [§4.3.3–4.3.4](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#433-créer-le-cluster) | `pvecm status` → 3/3 |
| NFS partagé | [§4.3.5](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#435-stockage-nfs-partagé-sur-pve03) | `pvesm status` → ha-nfs |

### ⚡ 12:00 — GO/NO-GO

| Critère | Test | Attendu |
|:--------|:-----|:--------|
| Quorum | `pvecm status` | `Quorate: Yes`, 3/3 |
| Inter-VLAN | `ping 192.168.20.1` depuis VLAN 10 | OK |
| Internet | `ping 8.8.8.8` | OK |
| DNS | `nslookup google.com 192.168.10.1` | Résolu |
| NFS | `pvesm status` | `ha-nfs` actif |
| Backup config | pfSense XML exporté | Fichier sauvé |

> 🔴 Si un critère échoue → STOP. Corriger avant de continuer.

### 12:15 — Identité + Services

| Étape | Runbook | Validation |
|:------|:--------|:-----------|
| AD-DC01 (provision) | [§4.4.1–4.4.5](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#441-vm-ad-dc01) | `kinit Administrator` |
| DNS records | [§4.4.6](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#446-enregistrements-dns) | `nslookup fs01.gaston.local` |
| AD-DC02 (réplica) | [§4.4.7](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#447-ad-dc02-réplica) | `samba-tool drs showrepl` |
| FS01 (partages SMB) | [§4.5.1](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#451-fs01--serveur-de-fichiers-windows-server-2022-datacenter-core) | `Get-SmbShare` → 7 partages |
| MAIL-01 (Mailcow) | [§4.5.2](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#452-mail-01--mailcow-dockerized) | `docker compose ps` → 15 containers |

### 14:00 — Monitoring + Backup

| Étape | Runbook | Validation |
|:------|:--------|:-----------|
| MON-01 (Checkmk) | [§4.6](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#46-supervision--mon-01-checkmk) | WebUI → 12 hôtes UP |
| PBS (backup server) | [§4.7](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#47-sauvegardes--pbs) | 1 backup + 1 restore OK |

### 15:00 — Production Web

| Étape | Runbook | Validation |
|:------|:--------|:-----------|
| MariaDB | [§4.8.1](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#481-maria-prod01) | `mysql -h .105 -u wp_user` OK |
| WordPress | [§4.8.2](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#482-web-wp01) | Apache running, WP config |
| NGINX RP | [§4.8.3](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#483-rp-prod01) | `curl -kI https://.106` → 200 |
| SSH hardening | [§4.8.4](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#484-durcissement-ssh-toutes-les-vms-prod) | PasswordAuth=no |
| HA Manager | [§4.8.5](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#485-ha-manager) | 8 VMs en HA |

### 17:00 — Sécurité + Recette

| Étape | Runbook | Validation |
|:------|:--------|:-----------|
| Sécurité J0 | [§5](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#5-sécurité-minimale-j0) | Checklist complète |
| Recette globale | [§6](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#6-checklist-de-recette-globale) | Tous les critères ✅ |
| Export configs | §5.5 | pfSense XML + snapshots |

### 18:00 — ✅ MVP Opérationnel

---

## Comment déployer PROD

Procédure exécutable complète. Chaque bloc est autonome avec sa validation.

### Pré-requis

- [ ] Cluster Proxmox opérationnel (3 nœuds, quorum OK, NFS partagé)
- [ ] Template cloud-init Debian 12 créé sur chaque nœud (VMID 9000)
- [ ] Template sysprep Windows Server 2022 (pour FS01)
- [ ] Réseau prêt : switch configuré, pfSense installé, VLANs 10/20/30 routés
- [ ] Secrets générés et stockés (voir [docs/ops/secrets.md](../ops/secrets.md))
- [ ] Terraform ≥ 1.6 et Ansible ≥ 2.15 installés sur la machine admin

### Étape 1 — Terraform : provisionner les VMs

```bash
cd iac/terraform/prod
cp terraform.tfvars.example terraform.tfvars
# Éditer terraform.tfvars :
#   pm_api_url    = "https://192.168.10.11:8006/api2/json"
#   node_prod     = "pve1"
#   node_infra    = "pve2"
#   node_secours  = "pve03"
#   ssh_public_keys = ["ssh-ed25519 AAAA..."]

export PM_API_TOKEN_ID="terraform@pam!iac"
export PM_API_TOKEN_SECRET="votre-token-secret"

terraform init
terraform plan -out=prod.tfplan
terraform apply prod.tfplan
```

**Validation :** `terraform output` → 9 VMs avec IPs correctes.

### Étape 2 — Ansible : configurer les VMs Linux

```bash
cd ../../../automation/ansible
cp inventories/prod.ini.example inventories/prod.ini
# Vérifier les IPs dans inventories/prod.ini

# Configuration de base sur toutes les VMs
ansible-playbook -i inventories/prod.ini playbooks/base-linux.yml

# Durcissement SSH + UFW + fail2ban
ansible-playbook -i inventories/prod.ini playbooks/hardening-min-j0.yml

# Stack web 3-tiers
ansible-playbook -i inventories/prod.ini playbooks/mariadb.yml
ansible-playbook -i inventories/prod.ini playbooks/wordpress.yml
ansible-playbook -i inventories/prod.ini playbooks/nginx-rp.yml

# Services infra
ansible-playbook -i inventories/prod.ini playbooks/mailcow.yml
ansible-playbook -i inventories/prod.ini playbooks/checkmk-agent.yml
```

**Validation :**

```bash
curl -k https://192.168.20.106     # → page WordPress via NGINX
ssh deploy@192.168.10.10           # → connexion AD-DC01
```

### Étape 3 — pfSense (manuel)

Configuration via WebUI (`https://192.168.10.1`).

Référence : [configs/pfsense/](../../configs/pfsense/)

- [ ] Aliases créés → [aliases.md](../../configs/pfsense/aliases.md)
- [ ] Règles firewall appliquées → [rules.md](../../configs/pfsense/rules.md)
- [ ] VPN OpenVPN configuré → [openvpn.md](../../configs/pfsense/openvpn.md)
- [ ] Export XML sauvegardé → [config-export.md](../../configs/pfsense/config-export.md)

### Étape 4 — Samba AD (manuel/semi-auto)

Exécuter les scripts templates sur AD-DC01 puis AD-DC02.

Référence : [configs/samba/](../../configs/samba/) · [Runbook §4.4](../../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#44-samba-ad-dc1--dc2)

```bash
# Sur AD-DC01 (192.168.10.10)
# Adapter configs/samba/provision.sh.template puis exécuter
bash provision.sh

# Créer les OUs et groupes
bash ou-groups.sh

# Sur AD-DC02 (192.168.10.9) — réplication
samba-tool domain join gaston.local DC -U Administrator
```

**Validation :** `samba-tool drs showrepl` → réplication OK.

### Étape 5 — PBS (manuel)

Installation et configuration du serveur de sauvegarde PBS.

Référence : [docs/ops/backup.md](../ops/backup.md)

- [ ] PBS installé sur VM `pbs` (192.168.30.100)
- [ ] Datastore configuré (AES-256-GCM, ZSTD)
- [ ] PVE → PBS : ajout du stockage PBS dans Proxmox
- [ ] Job de backup planifié (quotidien)
- [ ] Test : 1 backup + 1 restore OK

### Étape 6 — FS01 Windows (template sysprep + PowerShell)

Cloner le template sysprep Windows Server 2022, puis configurer via PowerShell.

Référence : [automation/powershell/](../../automation/powershell/)

```powershell
# Sur FS01 après le premier boot
# 1. Bootstrap (réseau, hostname, jonction domaine)
.\fs01-bootstrap.ps1

# 2. Après redémarrage et jonction au domaine
.\fs01-shares.ps1
```

**Validation :** `Get-SmbShare` → 7 partages SMB configurés.
