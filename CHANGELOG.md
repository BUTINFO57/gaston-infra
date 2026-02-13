# Journal des modifications

Toutes les modifications notables de ce projet sont documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/),
et ce projet adhère au [Versionnage Sémantique](https://semver.org/lang/fr/).

## [1.1.0] — 2026-02-13

### Ajouté

- **IaC Terraform** : provisioning Proxmox complet (modules `vm`, `network`, `cloudinit`)
- Environnement LAB mono-hôte et PROD multi-nœuds avec cloud-init
- Makefile avec cibles `lint`, `docs`, `lab-plan`, `lab-apply`, `prod-plan`, `prod-apply`
- Script `tools/tf-to-ansible-inventory.sh` : génération d'inventaire Ansible depuis Terraform
- CI renforcée : `terraform fmt/validate`, `ansible-lint`, `shellcheck`, job `policy`
- Dependabot pour les GitHub Actions
- Guide `docs/ops/secrets.md` : gestion des secrets en local
- Documentation deploy-first : parcours LAB 60 min et PROD 1 journée
- Section « Ce qui reste manuel et pourquoi » dans README et docs/prod/overview
- Bloc exécutable « Comment déployer PROD » dans docs/prod/day0-runbook.md
- Tableaux « Variables à fournir » dans iac/terraform/README.md et automation/ansible/README.md
- Registre TODO enrichi (003–006 avec variable de paramétrage)
- Compteur de fichiers : 73 → 107 fichiers (ajout IaC + templates + configs)

### Modifié

- README refondu : page d'accueil IaC avec badges, commandes copiables, architecture
- README : sections « Démarrer LAB/PROD » avec commandes exactes et validation
- SECURITY.md : signalement via GitHub Private Vulnerability Reporting (sans email inventé)
- CONTRIBUTING.md : Conventional Commits en français, règles PR, commandes `make`
- `.gitignore` : protection `*.tfstate`, `*.tfvars`, `.terraform/`
- Quickstart aligné sur le parcours Terraform → Ansible
- Badges README pointent vers `BUTINFO57/gaston-infra`
- `.markdownlint.yml` : désactivation des règles de style non bloquantes (MD060, MD036, MD028, MD029, MD040)

### Corrigé

- Résolution du placeholder `TODO-OWNER` dans badges et quickstart
- Résolution du `TODO[002]` (contact sécurité) via Private Vulnerability Reporting

## [1.0.0] — 2026-02-09

### Ajouté

- Runbook complet : guide de déploiement J0 (12 sections + 4 annexes)
- Checklist exécutive 20 minutes (`RUNBOOK-EXEC-20MIN.md`)
- Guide LAB : déploiement mono-hôte Proxmox
- Guide PROD : déploiement cluster 3 nœuds
- Documentation architecture : diagrammes, plan IP, matrice de flux
- Guides opérations : sauvegarde, supervision, rollback, dépannage
- Playbooks Ansible : durcissement de base, UFW, fail2ban, SSH, NGINX, WordPress, MariaDB, agent Checkmk, Mailcow
- Scripts PowerShell : bootstrap et partages FS01
- Modèles de configuration : NGINX, UFW, provisionnement Samba AD
- Documentation pfSense : alias, règles, OpenVPN, export config
- CI GitHub Actions : markdownlint, vérification liens, validation mermaid, scan secrets
- Modèles de tickets et PR
- Fichiers exemples pour secrets, hôtes, configuration réseau

## [0.2.0] — 2026-02-08

### Ajouté

- Couche automatisation : rôles Ansible (common, ufw, fail2ban, ssh)
- Scripts PowerShell FS01
- Modèles de configuration
- Outils : scripts de validation

## [0.1.0] — 2026-02-07

### Ajouté

- Structure initiale du dépôt
- README avec présentation du projet et deux parcours de déploiement
- Squelette de documentation
- Runbook v2.0 importé depuis les sources
- Licence, politique de sécurité, guide de contribution

