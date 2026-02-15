# Journal des modifications

Toutes les modifications notables de ce projet sont documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/),
et ce projet adhère au [Versionnage Sémantique](https://semver.org/lang/fr/).

## [1.2.0] — 2026-02-15

### Ajouté

- Templates Ansible manquants : `wp-config.php.j2` (WordPress) et `nginx-rp.conf.j2` (reverse proxy)
- Job `yamllint` global dans le workflow CI
- Marqueurs `---` (document-start) dans tous les fichiers YAML
- Fichiers `.terraform.lock.hcl` (lab + prod) pour reproductibilité des builds

### Corrigé

- **IaC** : variables d'environnement provider `bpg/proxmox` corrigées (`PM_*` → `PROXMOX_VE_*`)
- **CI** : suppression de `|| true` sur `shellcheck` (les erreurs étaient masquées)
- **CI** : suppression du workflow `lint.yml` redondant (jobs déjà dans `ci.yml`)
- **Outils** : bug sous-shell dans `validate-mermaid.sh` (compteur d'erreurs toujours à 0)
- **Runbook** : résolution de tous les TODOs techniques (001–006)
  - TODO[001] : communauté SNMP → `gaston_monitor`
  - TODO[002] : Auth Container LDAP → `OU=CORPO,DC=gaston,DC=local`
  - TODO[003] : URL Checkmk → version 2.4.0p5
  - TODO[004] : PBS = 1 NIC sur VLAN 30 (`192.168.30.100`)
  - TODO[005] : GLPI = Debian 12 + GLPI 9.5
  - TODO[006] : IPs VLAN 20 = `.105/.106/.108` (conformes pfSense)
- **Docs** : correction double `)` dans `ip-plan.md`, version GLPI 10.0 → 9.5
- **Docs** : Auth Container OpenVPN aligné sur les rapports
- **Docs** : suppression de la section anglaise « Git History Plan » dans `docs/index.md`
- **Shell** : SC2329 (`cleanup` via trap) et SC2001 (parameter expansion `${1%%/*}` au lieu de `sed`)
- **Git** : `.gitignore` renforcé — exclusion des rapports source et artefacts de travail

### Modifié

- Registres TODO mis à jour (tous ✅) dans `docs/index.md`, `iac/terraform/README.md`, `automation/ansible/README.md`
- Badge README : suppression du badge `lint.yml` obsolète
- Exemptions policy CI : ajout `.j2`, `RUNBOOK-`, `CONTRIBUTING`, `CHANGELOG`

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
