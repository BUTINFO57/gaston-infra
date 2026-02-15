# 📚 Documentation — gaston-infra

Bienvenue dans la documentation du projet **Les Saveurs de Gaston**.

## Parcours de lecture

```text
README.md                     → Vue d'ensemble et commandes rapides
  └─→ docs/quickstart.md      → Démarrage en 5 minutes
       ├─→ LAB (recommandé)   → Déploiement mono-hôte en 60 min
       └─→ PROD               → Déploiement 3 nœuds en 1 journée
            └─→ ops/           → Opérations quotidiennes
```

## Navigation

| Guide | Description | Public |
|:------|:------------|:-------|
| [Quickstart](quickstart.md) | Démarrer en 5 minutes | Tout le monde |
| [Lab — Single Host](lab/overview.md) | Déployer sur 1 seul PC | Étudiants, homelab |
| [Prod — 3 Nodes](prod/overview.md) | Déploiement complet J0 | Production |
| [Architecture](architecture/diagrams.md) | Schémas, IP plan, flux | Référence |
| [Operations](ops/backup.md) | Backup, monitoring, rollback | Ops / Admin |
| [Secrets](ops/secrets.md) | Gestion des secrets en local | Ops / Admin |
| [Terraform](../iac/terraform/README.md) | IaC — provisioning Proxmox | DevOps |
| [Ansible](../automation/ansible/README.md) | Configuration management | DevOps |

## Runbooks

Les procédures exécutables sont dans [`/runbooks/`](../runbooks/) :

- [Runbook J0 complet](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md)
- [Checklist exécutive 20 min](../runbooks/RUNBOOK-EXEC-20MIN.md)

## Templates de configuration

| Template | Guide associé |
|:---------|:-------------|
| [configs/nginx/rp-prod01.conf.template](../configs/nginx/rp-prod01.conf.template) | [Runbook §4.8](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#48-production-web--3-tiers) |
| [configs/ufw/ufw-web.template](../configs/ufw/ufw-web.template) | [Playbook hardening](../automation/ansible/playbooks/hardening-min-j0.yml) |
| [configs/ufw/ufw-db.template](../configs/ufw/ufw-db.template) | [Playbook hardening](../automation/ansible/playbooks/hardening-min-j0.yml) |
| [configs/samba/provision.sh.template](../configs/samba/provision.sh.template) | [Runbook §4.4](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#44-samba-ad-dc1--dc2) |
| [configs/samba/ou-groups.sh.template](../configs/samba/ou-groups.sh.template) | [Runbook §4.4](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#44-samba-ad-dc1--dc2) |
| [configs/pfsense/](../configs/pfsense/) | [Runbook §4.2](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#42-pfsense-ce) |

## Playbooks Ansible

| Playbook | Cible | Guide |
|:---------|:------|:------|
| [base-linux.yml](../automation/ansible/playbooks/base-linux.yml) | Toutes les VMs Linux | [Quickstart §4](quickstart.md#étape-4--configurer-les-services-avec-ansible-30-min) |
| [hardening-min-j0.yml](../automation/ansible/playbooks/hardening-min-j0.yml) | Durcissement SSH/UFW/fail2ban | [Runbook §4.10](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md) |
| [mariadb.yml](../automation/ansible/playbooks/mariadb.yml) | maria-prod01 | [Runbook §4.8](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#48-production-web--3-tiers) |
| [wordpress.yml](../automation/ansible/playbooks/wordpress.yml) | web-wp01 | [Runbook §4.8](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#48-production-web--3-tiers) |
| [nginx-rp.yml](../automation/ansible/playbooks/nginx-rp.yml) | rp-prod01 | [Runbook §4.8](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#48-production-web--3-tiers) |
| [checkmk-agent.yml](../automation/ansible/playbooks/checkmk-agent.yml) | Toutes les VMs | [Runbook §4.6](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#46-supervision--mon-01-checkmk) |
| [mailcow.yml](../automation/ansible/playbooks/mailcow.yml) | mail-01 | [Runbook §4.5](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#45-services-socle) |

---

## Registre TODO (global)

| ID | Description | Emplacement | Statut |
|:---|:-----------|:------------|:-------|
| TODO[001] | Propriétaire du dépôt GitHub | `README.md` | ✅ Résolu (`BUTINFO57`) |
| TODO[002] | Contact sécurité | `SECURITY.md` | ✅ Résolu (GitHub Private Reporting) |
| TODO[003] | IP monitoring PBS | `runbooks/` + `docs/ops/monitoring.md` | ✅ Résolu — PBS = `192.168.30.100` (1 NIC VLAN 30) |
| TODO[004] | IPs PROD VLAN 20 | `docs/architecture/ip-plan.md` | ✅ Résolu — `.105/.106/.108` (conformes aux règles pfSense) |
| TODO[005] | OS GLPI | `docs/architecture/ip-plan.md` | ✅ Résolu — Debian 12 + GLPI 9.5 |
| TODO[006] | Auth Container LDAP pfSense VPN | `configs/pfsense/openvpn.md` | ✅ Résolu — `OU=CORPO,DC=gaston,DC=local` |

> **Tous les TODOs techniques sont résolus.** Les TODOs restants dans le runbook (007–010) sont des actions runtime (mots de passe, DKIM, interfaces matérielles) qui dépendent de l'environnement réel.
> Voir aussi : [iac/terraform/README.md](../iac/terraform/README.md#todos-liés-à-terraform) · [automation/ansible/README.md](../automation/ansible/README.md#todos-liés-à-ansible)

---

## Historique des versions

| Tag | Description |
|:----|:-----------|
| `v0.1.0` | Scaffolding — structure, CI, fichiers communautaires |
| `v0.2.0` | Documentation complète — architecture, runbooks, guides |
| `v1.0.0` | Release initiale — templates, Ansible, Terraform, outils |
