# 🏗️ gaston-infra

<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

![License](https://img.shields.io/github/license/TODO-OWNER/gaston-infra?style=flat-square)
![CI](https://img.shields.io/github/actions/workflow/status/TODO-OWNER/gaston-infra/ci.yml?label=CI&style=flat-square)
![Markdown](https://img.shields.io/github/actions/workflow/status/TODO-OWNER/gaston-infra/lint.yml?label=lint&style=flat-square)

**Projet SAE — Déploiement d'une infrastructure enterprise-grade pour une PME**
Réseau segmenté · Virtualisation HA · Identité centralisée · Site web 3-tiers · Sauvegarde chiffrée

</div>
<!-- markdownlint-enable MD033 MD041 -->

> TODO[001]: Remplacer `TODO-OWNER` par le nom GitHub réel | Où: README.md#badges | Attendu: `owner/gaston-infra` | Exemple: `mathieu-dupont/gaston-infra`

---

## ⚡ What You Get

| Bloc | Technologies | Résultat |
|:-----|:-------------|:---------|
| 🔀 Réseau | pfSense CE 24.0 · Switch SG350-28 · 3 VLANs | Deny-by-default, VPN OpenVPN/LDAPS |
| 🖥️ Virtualisation | Proxmox VE 9.0 · 3 nœuds cluster | HA Manager, RTO < 90 s, NFS v4.2 |
| 🔐 Identité | Samba AD (2 DC) · Kerberos · AGDLP | Tiering Tier-0/1/2, ~150 comptes |
| 📂 Fichiers | Windows Server 2022 Core (FS01) | 7 partages SMB 3.1.1, RBAC NTFS |
| 📧 Messagerie | Mailcow Dockerized | Postfix+Dovecot+SOGo+Rspamd (15 containers) |
| 📡 Supervision | Checkmk Raw 2.4 | 12 hôtes, agents TLS |
| 💾 Sauvegarde | PBS v3 (VLAN isolé) | AES-256-GCM, ZSTD, dédup 70-90 % |
| 🌐 Site web | NGINX + WordPress + MariaDB | Architecture 3-tiers, `/wp-admin` filtré |

---

## 🚀 Two Paths

### 🧪 LAB — Single Host (30 min setup → deploy)

> Tout sur **1 seul PC/serveur** avec Proxmox. Pas de HA réel, même architecture logique.

```text
You need: 1 machine (16+ Go RAM, 256+ Go SSD), 1 NIC
Result:   Même stack complète, VLANs virtuels, pas de cluster HA
```

➡️ **[Start here → docs/lab/overview.md](docs/lab/overview.md)**

### 🏭 PROD — 3 Nodes (full day deploy)

> Déploiement conforme au runbook : 3 serveurs + switch + pfSense dédié.

```text
You need: 3 servers, 1 pfSense box (2 NIC), 1 switch SG350-28
Result:   Cluster HA 3 nœuds, quorum natif, failover auto < 90 s
```

➡️ **[Start here → docs/prod/overview.md](docs/prod/overview.md)**

---

## 📋 One-Day Checklist

| Heure | Bloc | Guide | Durée |
|:-----:|:-----|:------|:-----:|
| 08:00 | 🔀 Switch + pfSense base install | [§4.1–4.2](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#41-switch-cisco-sg350-28) | 1 h 30 |
| 09:30 | 🖥️ Proxmox cluster + NFS | [§4.3](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#43-cluster-proxmox-ve) | 1 h 45 |
| 11:15 | ⚡ **GO/NO-GO** checkpoint | [§3](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#3-plan-dexécution-sur-1-journée) | 15 min |
| 11:30 | 🔐 Samba AD DC01+DC02 | [§4.4](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#44-samba-ad-dc1--dc2) | 1 h 15 |
| 12:45 | 📂📧 FS01 + Mailcow | [§4.5](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#45-services-socle) | 1 h 15 |
| 14:00 | 📡💾 Checkmk + PBS | [§4.6–4.7](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#46-supervision--mon-01-checkmk) | 1 h 20 |
| 15:20 | 🌐 Web 3-tiers | [§4.8](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#48-production-web--3-tiers) | 1 h 00 |
| 16:20 | 🛡️ Sécurité J0 + recette | [§5–6](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#5-sécurité-minimale-j0) | 1 h 00 |
| 17:20 | ✅ **MVP Opérationnel** | | |

➡️ **[Full runbook](runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md)** · **[20-min exec checklist](runbooks/RUNBOOK-EXEC-20MIN.md)**

---

## 📂 Repository Structure

```text
gaston-infra/
├── docs/                          # Documentation
│   ├── quickstart.md              # Get started in 5 min
│   ├── lab/                       # Single-host lab guide
│   ├── prod/                      # 3-node production guide
│   ├── ops/                       # Operations (backup, monitoring, rollback)
│   └── architecture/              # Diagrams, IP plan, flows
├── runbooks/                      # Executable runbooks
│   ├── RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md
│   └── RUNBOOK-EXEC-20MIN.md
├── configs/                       # Configuration templates
│   ├── nginx/                     # NGINX reverse proxy
│   ├── ufw/                       # UFW firewall rules
│   ├── pfsense/                   # pfSense documentation
│   └── samba/                     # Samba AD provisioning
├── automation/                    # Deployment automation
│   ├── ansible/                   # Ansible playbooks & roles
│   └── powershell/                # FS01 PowerShell scripts
├── tools/                         # Validation scripts
├── examples/                      # Example configs (no secrets)
└── .github/                       # CI/CD + templates
```

---

## ⚠️ Public Repository Notice

This repository is **public**. It does **not** contain:

- ❌ Real passwords, API keys, or secrets
- ❌ Production credentials or private IPs
- ❌ Customer or employee personal data

All sensitive values use `<PLACEHOLDER>` markers and `.example` files.
See [SECURITY.md](SECURITY.md) for the security policy.

---

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).

## 📜 License

[MIT](LICENSE) — See [LICENSE](LICENSE) for details.
