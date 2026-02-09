# Journal des modifications

Toutes les modifications notables de ce projet sont documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/),
et ce projet adhère au [Versionnage Sémantique](https://semver.org/lang/fr/).

## [1.0.1] — 2026-02-09

### Corrigé

- Résolution des 6 TODO documentaires (owner GitHub, contact sécurité, PBS NIC, IPs PROD, GLPI OS, Auth Container LDAP)
- Harmonisation des IPs PVE dans tous les inventaires (.11/.12/.50)
- Ajout newline en fin de .markdownlint.yml (yamllint)
- Nettoyage de la référence TODO[006] résiduelle dans openvpn.md

### Amélioré

- README.md réécrit intégralement en français (parcours LAB/PROD, badges, structure)
- SECURITY.md : politique via GitHub Security Advisories
- docs/quickstart.md : guide de démarrage rapide en français
- docs/index.md : registre des décisions techniques + références configs
- docs/lab/overview.md : checklist express 30 min, table des simulations
- docs/lab/single-host-proxmox.md : URLs ISO réelles, config 16 Go RAM
- docs/prod/day0-runbook.md : tableau de rollback par phase
- docs/prod/validation.md : résultats attendus (pvecm, samba, docker, curl, HA)

### Ajouté

- .markdownlint.yml, .markdownlint-cli2.jsonc, .yamllint.yml
- 9 topics GitHub, 7 labels en français, protection branche main

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
