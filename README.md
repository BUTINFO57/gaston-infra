# 🏗️ gaston-infra

<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

![License](https://img.shields.io/github/license/butinfoia-alt/gaston-infra?style=flat-square)
![CI](https://img.shields.io/github/actions/workflow/status/butinfoia-alt/gaston-infra/ci.yml?label=CI&style=flat-square)
![Lint](https://img.shields.io/github/actions/workflow/status/butinfoia-alt/gaston-infra/lint.yml?label=lint&style=flat-square)

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
git clone https://github.com/butinfoia-alt/gaston-infra.git
cd gaston-infra
```

➡️ **[docs/quickstart.md](docs/quickstart.md)** — Guide complet de démarrage

### 🧪 Parcours LAB (recommandé) — 1 heure

> **1 seul PC/serveur** avec Proxmox. Même architecture logique, sans HA.

```bash
# 1. Préparer le template cloud-init Debian (voir iac/terraform/README.md)
# 2. Provisionner les VMs
cd iac/terraform/lab
cp terraform.tfvars.example terraform.tfvars    # éditer avec vos valeurs
terraform init && terraform plan -out=lab.tfplan && terraform apply lab.tfplan

# 3. Générer l'inventaire Ansible
bash ../../../tools/tf-to-ansible-inventory.sh lab

# 4. Configurer les services
cd ../../../automation/ansible
ansible-playbook -i inventories/lab.ini playbooks/base-linux.yml
ansible-playbook -i inventories/lab.ini playbooks/hardening-min-j0.yml
```

➡️ **[Guide LAB complet](docs/lab/overview.md)**

### 🏭 Parcours PROD — 1 journée

> 3 serveurs physiques + switch + pfSense dédié. Cluster HA 3 nœuds.

➡️ **[Guide PROD](docs/prod/overview.md)** · **[Runbook J0](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md)**

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
