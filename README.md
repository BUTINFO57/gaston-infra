# 🏗️ gaston-infra

<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

![License](https://img.shields.io/github/license/BUTINFO57/gaston-infra?style=flat-square)
![CI](https://img.shields.io/github/actions/workflow/status/BUTINFO57/gaston-infra/ci.yml?label=CI&style=flat-square)
![Lint](https://img.shields.io/github/actions/workflow/status/BUTINFO57/gaston-infra/lint.yml?label=lint&style=flat-square)

**Infrastructure as Code — Les Saveurs de Gaston (LAB + PROD)**

Terraform · Ansible · Proxmox · pfSense · Samba AD · 3 VLANs · CI/CD

</div>
<!-- markdownlint-enable MD033 MD041 -->

---

## 📖 À propos

Dépôt IaC complet pour déployer l'infrastructure **Les Saveurs de Gaston**,
une PME fictive avec une architecture enterprise-grade.

**Provisioning** via Terraform (VMs Proxmox + cloud-init) puis **configuration**
via Ansible (durcissement, services, stack web).

| Bloc | Technologies | Résultat |
|:-----|:-------------|:---------|
| 🔀 Réseau | pfSense CE 24.0 · Switch SG350-28 · 3 VLANs | Deny-by-default, VPN OpenVPN/LDAPS |
| 🖥️ Virtualisation | Proxmox VE 9.0 · 3 nœuds cluster | HA Manager, RTO < 90 s, NFS v4.2 |
| 🔐 Identité | Samba AD (2 DC) · Kerberos · AGDLP | Tiering Tier-0/1/2, ~150 comptes |
| 📂 Fichiers | Windows Server 2022 Core (FS01) | 7 partages SMB 3.1.1, RBAC NTFS |
| 📧 Messagerie | Mailcow Dockerized | Postfix+Dovecot+SOGo+Rspamd |
| 📡 Supervision | Checkmk Raw 2.4 | 12 hôtes, agents TLS |
| 💾 Sauvegarde | PBS v3 (VLAN isolé) | AES-256-GCM, ZSTD, dédup 70-90 % |
| 🌐 Site web | NGINX + WordPress + MariaDB | Architecture 3-tiers, `/wp-admin` filtré |

---

## 🚀 Démarrage rapide

```bash
git clone https://github.com/BUTINFO57/gaston-infra.git
cd gaston-infra
```

➡️ **[docs/quickstart.md](docs/quickstart.md)** — Guide complet de démarrage

---

## 🧪 Démarrer — LAB en 60 minutes

> **1 seul PC/serveur** avec Proxmox VE ≥ 8.0 + template cloud-init Debian.
> Même architecture logique que la PROD, sans HA.

```bash
# 1. Provisionner les VMs
cd iac/terraform/lab
cp terraform.tfvars.example terraform.tfvars    # ← éditer avec vos valeurs
export PM_API_TOKEN_ID="terraform@pam!iac"
export PM_API_TOKEN_SECRET="votre-token-secret"
terraform init
terraform plan -out=lab.tfplan
terraform apply lab.tfplan

# 2. Générer l'inventaire Ansible
cd ../../..
bash tools/tf-to-ansible-inventory.sh lab

# 3. Configurer les services
cd automation/ansible
ansible-playbook -i inventories/lab.ini playbooks/base-linux.yml
ansible-playbook -i inventories/lab.ini playbooks/hardening-min-j0.yml
ansible-playbook -i inventories/lab.ini playbooks/mariadb.yml
ansible-playbook -i inventories/lab.ini playbooks/wordpress.yml
ansible-playbook -i inventories/lab.ini playbooks/nginx-rp.yml
```

**Validation rapide :**

```bash
curl -k https://192.168.20.106          # → page WordPress
ssh deploy@192.168.10.10                 # → connexion AD-DC01
terraform -chdir=iac/terraform/lab output  # → IPs de toutes les VMs
```

➡️ **[Guide LAB complet](docs/quickstart.md#5-déploiement-lab-en-60-minutes)** · **[Lab overview](docs/lab/overview.md)**

---

## 🏭 Démarrer — PROD en 1 journée

> 3 serveurs physiques + switch + pfSense dédié. Cluster HA 3 nœuds.

```bash
# 1. Provisionner les VMs sur le cluster
cd iac/terraform/prod
cp terraform.tfvars.example terraform.tfvars    # ← placement multi-nœuds
terraform init
terraform plan -out=prod.tfplan
terraform apply prod.tfplan

# 2. Configurer avec Ansible
cd ../../../automation/ansible
cp inventories/prod.ini.example inventories/prod.ini
ansible-playbook -i inventories/prod.ini playbooks/base-linux.yml
ansible-playbook -i inventories/prod.ini playbooks/hardening-min-j0.yml
ansible-playbook -i inventories/prod.ini playbooks/mailcow.yml
ansible-playbook -i inventories/prod.ini playbooks/checkmk-agent.yml
ansible-playbook -i inventories/prod.ini playbooks/nginx-rp.yml
ansible-playbook -i inventories/prod.ini playbooks/mariadb.yml
ansible-playbook -i inventories/prod.ini playbooks/wordpress.yml
```

**Parties manuelles** (attendues — voir section dédiée ci-dessous) :

| Service | Guide | Durée |
|:--------|:------|:-----:|
| pfSense (routage, FW, VPN) | [configs/pfsense/](configs/pfsense/) | 1 h 30 |
| Samba AD (DC01 + DC02) | [configs/samba/](configs/samba/) | 1 h 15 |
| FS01 Windows (partages SMB) | [automation/powershell/](automation/powershell/) | 30 min |
| PBS (sauvegarde) | [docs/ops/backup.md](docs/ops/backup.md) | 30 min |

➡️ **[Guide PROD](docs/prod/overview.md)** · **[Runbook J0](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md)** · **[Day0 Runbook](docs/prod/day0-runbook.md)**

---

## 📋 Checklist déploiement J0

| Heure | Bloc | Guide | Durée |
|:-----:|:-----|:------|:-----:|
| 08:00 | 🔀 Switch + pfSense | [§4.1–4.2](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#41-switch-cisco-sg350-28) | 1 h 30 |
| 09:30 | 🖥️ Proxmox cluster + NFS | [§4.3](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#43-cluster-proxmox-ve) | 1 h 45 |
| 11:15 | ⚡ **GO/NO-GO** | [§3](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#3-plan-dexécution-sur-1-journée) | 15 min |
| 11:30 | 🔐 Samba AD | [§4.4](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#44-samba-ad-dc1--dc2) | 1 h 15 |
| 12:45 | 📂📧 FS01 + Mailcow | [§4.5](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#45-services-socle) | 1 h 15 |
| 14:00 | 📡💾 Checkmk + PBS | [§4.6–4.7](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#46-supervision--mon-01-checkmk) | 1 h 20 |
| 15:20 | 🌐 Web 3-tiers | [§4.8](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#48-production-web--3-tiers) | 1 h 00 |
| 16:20 | 🛡️ Sécurité + recette | [§5–6](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#5-sécurité-minimale-j0) | 1 h 00 |
| 17:20 | ✅ **MVP Opérationnel** | | |

---

## 🏗️ Architecture IaC

```text
Terraform provisionne          Ansible configure
┌──────────────────┐           ┌──────────────────┐
│  iac/terraform/  │           │ automation/       │
│  ├── modules/    │  ──────>  │  ansible/         │
│  ├── lab/        │  outputs  │  ├── playbooks/   │
│  └── prod/       │           │  ├── roles/       │
└──────────────────┘           │  └── inventories/ │
                               └──────────────────┘
```

## 📂 Structure du dépôt

```text
gaston-infra/
├── iac/                           # Infrastructure as Code
│   └── terraform/                 # Provisioning Proxmox
│       ├── modules/               #   Modules réutilisables (vm, network, cloudinit)
│       ├── lab/                   #   Environnement LAB mono-hôte
│       └── prod/                  #   Environnement PROD multi-nœuds
├── automation/                    # Configuration management
│   ├── ansible/                   #   Playbooks, rôles, inventaires
│   └── powershell/                #   Scripts FS01 (Windows)
├── configs/                       # Templates de configuration
│   ├── nginx/                     #   Reverse proxy NGINX
│   ├── ufw/                       #   Règles pare-feu UFW
│   ├── pfsense/                   #   Documentation pfSense
│   └── samba/                     #   Provisionnement Samba AD
├── docs/                          # Documentation
│   ├── quickstart.md              #   Démarrage rapide
│   ├── lab/                       #   Guide LAB mono-hôte
│   ├── prod/                      #   Guide PROD 3 nœuds
│   ├── ops/                       #   Opérations (backup, monitoring, secrets)
│   └── architecture/              #   Diagrammes, plan IP, flux
├── runbooks/                      # Procédures exécutables
├── tools/                         # Scripts de validation et utilitaires
├── examples/                      # Fichiers exemples (sans secrets)
├── Makefile                       # Cibles make (lint, deploy, validate)
└── .github/                       # CI/CD GitHub Actions
```

## 🔧 Commandes Make

```bash
make help              # Afficher toutes les cibles
make lint              # Exécuter tous les linters
make docs              # Valider liens et diagrammes Mermaid
make lab-plan          # Planifier le déploiement LAB
make lab-apply         # Appliquer le déploiement LAB
make prod-plan         # Planifier le déploiement PROD
make prod-apply        # Appliquer le déploiement PROD
make validate          # Validation complète (lint + docs)
```

---

## 🔧 Ce qui reste manuel et pourquoi

Certains composants ne sont **pas** automatisés par Terraform/Ansible.
C'est un choix de conception documenté (pas un oubli).

| Composant | Raison | Référence |
|:----------|:-------|:----------|
| **pfSense** | Pas d'API Terraform fiable et stable. Config via WebUI + export XML. | [configs/pfsense/](configs/pfsense/) |
| **Samba AD** | Provisionnement automatisable mais risque élevé. Scripts templates + exécution manuelle. | [configs/samba/](configs/samba/) |
| **PBS** | Intégration PVE↔PBS partiellement manuelle selon l'infrastructure physique. | [docs/ops/backup.md](docs/ops/backup.md) |
| **FS01 Windows** | Dépend d'un template sysprep (non généré automatiquement). Config via PowerShell post-deploy. | [automation/powershell/](automation/powershell/) |
| **Switch SG350** | Configuration VLAN via WebUI Cisco. Pas d'API IaC standard. | [runbooks/](runbooks/) |
| **Proxmox cluster** | Mise en cluster (pvecm) = opération manuelle unique sur chaque nœud. | [docs/prod/day0-runbook.md](docs/prod/day0-runbook.md) |

> Les checklists et templates sont fournis pour chaque composant manuel.
> L'objectif est la **reproductibilité documentée**, pas l'automatisation totale.

---

## ⚠️ Dépôt public — Aucun secret

Ce dépôt est **public**. Il ne contient **aucun** :

- mot de passe, clé API ou token réel
- identifiant de production
- donnée personnelle

Tous les secrets utilisent des marqueurs `<PLACEHOLDER>` et des fichiers `.example`.
Voir [SECURITY.md](SECURITY.md) et [docs/ops/secrets.md](docs/ops/secrets.md).

---

## 🤝 Contribuer

Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour les conventions (Conventional Commits en français, règles PR).
Ce projet suit le [Code de Conduite Contributor Covenant](CODE_OF_CONDUCT.md).

## 📜 Licence

[MIT](LICENSE) — Voir [LICENSE](LICENSE) pour les détails.
