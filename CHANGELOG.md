# Journal des modifications

Toutes les modifications notables de ce projet sont documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/),
et ce projet adhère au [Versionnage Sémantique](https://semver.org/lang/fr/).

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
