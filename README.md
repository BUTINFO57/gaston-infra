# 🏗️ gaston-infra

<!-- markdownlint-disable MD033 MD036 MD041 -->
<div align="center">

![Licence](https://img.shields.io/github/license/butinfoia-alt/gaston-infra?style=flat-square)
![CI](https://img.shields.io/github/actions/workflow/status/butinfoia-alt/gaston-infra/ci.yml?label=CI&style=flat-square)
![Lint](https://img.shields.io/github/actions/workflow/status/butinfoia-alt/gaston-infra/lint.yml?label=lint&style=flat-square)

**Projet SAÉ — Déploiement d'une infrastructure entreprise pour une PME**

Réseau segmenté · Virtualisation HA · Identité centralisée · Site web 3-tiers · Sauvegarde chiffrée

</div>
<!-- markdownlint-enable MD033 MD041 -->

---

## 📋 C'est quoi ?

Un dépôt **Infrastructure-as-Code** complet pour déployer l'infrastructure IT d'une PME
(*Les Saveurs de Gaston*, ~150 postes) **en une journée**.

Il contient : documentation d'architecture, runbooks pas-à-pas, playbooks Ansible,
scripts PowerShell, modèles de configuration et outils de validation.

## 👤 Pour qui ?

- **Étudiants** — reproduire l'architecture en LAB sur 1 seul PC
- **Techniciens** — déployer en PROD avec le runbook copier-coller
- **Formateurs** — base pédagogique pour l'enseignement réseau/système

---

## ⚡ Ce que ça déploie

| Bloc | Technologies | Résultat |
|:-----|:-------------|:---------|
| 🔀 Réseau | pfSense CE 24.0 · Switch SG350-28 · 3 VLANs | Deny-by-default, VPN OpenVPN/LDAPS |
| 🖥️ Virtualisation | Proxmox VE 9.0 · 3 nœuds cluster | HA Manager, RTO < 90 s, NFS v4.2 |
| 🔐 Identité | Samba AD (2 DC) · Kerberos · AGDLP | Tiering Tier-0/1/2, ~150 comptes |
| 📂 Fichiers | Windows Server 2022 Core (FS01) | 7 partages SMB 3.1.1, RBAC NTFS |
| 📧 Messagerie | Mailcow Dockerized | Postfix+Dovecot+SOGo+Rspamd (15 conteneurs) |
| 📡 Supervision | Checkmk Raw 2.4 | 12 hôtes, agents TLS |
| 💾 Sauvegarde | PBS v3 (VLAN isolé) | AES-256-GCM, ZSTD, dédup 70-90 % |
| 🌐 Site web | NGINX + WordPress + MariaDB | Architecture 3-tiers, `/wp-admin` filtré |

---

## 🚀 Deux parcours de déploiement

### 🧪 LAB — un seul PC (≈ 4 h)

> Tout sur **1 machine** avec Proxmox. Pas de HA réel, même architecture logique.

```text
Prérequis : 1 machine (16+ Go RAM, 256+ Go SSD), 1 carte réseau
Résultat  : stack complète, VLANs virtuels (bridges), pas de cluster HA
```

➡️ **[Commencer ici → docs/lab/overview.md](docs/lab/overview.md)**

### 🏭 PROD — 3 serveurs (≈ 1 journée)

> Déploiement conforme au runbook : 3 serveurs + switch + pfSense dédié.

```text
Prérequis : 3 serveurs, 1 PC pfSense (2 cartes réseau), 1 switch SG350-28
Résultat  : cluster HA 3 nœuds, quorum natif, failover auto < 90 s
```

➡️ **[Commencer ici → docs/prod/overview.md](docs/prod/overview.md)**

---

## 🗓️ Planning type J0 (PROD)

| Heure | Bloc | Guide | Durée |
|:-----:|:-----|:------|:-----:|
| 08:00 | 🔀 Switch + pfSense | §4.1–4.2 | 1 h 30 |
| 09:30 | 🖥️ Cluster Proxmox + NFS | §4.3 | 1 h 45 |
| 11:15 | ⚡ **GO/NO-GO** | §3 | 15 min |
| 11:30 | 🔐 Samba AD DC01+DC02 | §4.4 | 1 h 15 |
| 12:45 | 📂📧 FS01 + Mailcow | §4.5 | 1 h 15 |
| 14:00 | 📡💾 Checkmk + PBS | §4.6–4.7 | 1 h 20 |
| 15:20 | 🌐 Web 3-tiers | §4.8 | 1 h 00 |
| 16:20 | 🛡️ Sécurité J0 + recette | §5–6 | 1 h 00 |
| 17:20 | ✅ **MVP opérationnel** | | |

➡️ **[Runbook complet](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md)** · **[Checklist exécutive 20 min](runbooks/RUNBOOK-EXEC-20MIN.md)**

---

## 🗺️ Navigation rapide

| Je veux… | Aller à |
|:---------|:--------|
| Comprendre l'architecture | [docs/architecture/diagrams.md](docs/architecture/diagrams.md) |
| Voir le plan IP / VLANs | [docs/architecture/ip-plan.md](docs/architecture/ip-plan.md) |
| Déployer en LAB (1 PC) | [docs/lab/overview.md](docs/lab/overview.md) |
| Déployer en PROD (3 serveurs) | [docs/prod/overview.md](docs/prod/overview.md) |
| Opérer (backup/monitoring/rollback) | [docs/ops/](docs/ops/) |
| Lancer l'automatisation Ansible | [automation/ansible/README.md](automation/ansible/README.md) |
| Voir les modèles de config | [configs/](configs/) |

---

## 📂 Structure du dépôt

```text
gaston-infra/
├── docs/                          # Documentation
│   ├── quickstart.md              # Démarrer en 5 min
│   ├── lab/                       # Guide LAB mono-hôte
│   ├── prod/                      # Guide PROD 3 nœuds
│   ├── ops/                       # Opérations (backup, monitoring, rollback)
│   └── architecture/              # Diagrammes, plan IP, flux
├── runbooks/                      # Runbooks exécutables
│   ├── RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md
│   └── RUNBOOK-EXEC-20MIN.md
├── configs/                       # Modèles de configuration
│   ├── nginx/                     # Reverse proxy NGINX
│   ├── ufw/                       # Règles pare-feu UFW
│   ├── pfsense/                   # Documentation pfSense
│   └── samba/                     # Provisionnement Samba AD
├── automation/                    # Automatisation du déploiement
│   ├── ansible/                   # Playbooks et rôles Ansible
│   └── powershell/                # Scripts PowerShell FS01
├── tools/                         # Scripts de validation
├── examples/                      # Fichiers d'exemple (sans secrets)
└── .github/                       # CI/CD + modèles
```

---

## ⚠️ Dépôt public — Aucun secret

Ce dépôt est **public**. Il ne contient **aucun** :

- ❌ Mot de passe, clé API ou token réel
- ❌ Identifiant de production ou IP publique
- ❌ Donnée personnelle (noms, emails, téléphones)

Toutes les valeurs sensibles utilisent des marqueurs `<PLACEHOLDER>` et des fichiers `.example`.
Voir [SECURITY.md](SECURITY.md) pour la politique de sécurité.

---

## 🤝 Contribuer

Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour les consignes.
Ce projet suit le [Code de Conduite Contributor Covenant](CODE_OF_CONDUCT.md).

## 📜 Licence

MIT — Voir [LICENSE](LICENSE) pour les détails.
