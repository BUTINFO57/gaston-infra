# Statut du dépôt

## État actuel

| Champ | Valeur |
|-------|--------|
| **Statut** | **Terminé** |
| **Date de clôture** | 15 février 2026 |
| **Tag latest** | `v1.3.0` |
| **Branche principale** | `main` |
| **CI** | 9/9 jobs verts |

---

## Périmètre couvert

### Automatisé (Terraform + Ansible)

- Provisioning VMs Proxmox (LAB mono-hôte + PROD multi-nœuds)
- Cloud-init Debian 12
- Durcissement Linux (SSH, UFW, fail2ban)
- Stack web 3-tiers (NGINX reverse proxy + WordPress + MariaDB)
- Mailcow Dockerized
- Agent Checkmk TLS

### Documenté et scriptable (guides + templates)

- pfSense CE 24.0 (routage, pare-feu, VPN OpenVPN/LDAPS)
- Samba AD (2 DC, réplication, AGDLP)
- PBS v3 (sauvegarde chiffrée, dédupliquée, VLAN isolé)
- FS01 Windows Server 2022 Core (7 partages SMB, RBAC NTFS)
- Switch Cisco SG350-28 (VLANs 10/20/30)
- Cluster Proxmox 3 nœuds (HA Manager)

### Volontairement manuel — raisons

| Composant | Raison |
|-----------|--------|
| pfSense | Pas d'API Terraform fiable et stable |
| Samba AD | Risque élevé — scripts templates + exécution supervisée |
| PBS | Intégration PVE↔PBS dépend de l'infrastructure physique |
| FS01 Windows | Dépend d'un template sysprep non générable automatiquement |
| Switch SG350 | Pas d'API IaC standard (WebUI Cisco) |
| Proxmox cluster | `pvecm` = opération manuelle unique par nœud |

---

## Politique de versionnage

Ce projet suit le [Versionnage Sémantique](https://semver.org/lang/fr/) :

- **MAJOR** (`X.0.0`) : changement d'architecture ou suppression de fonctionnalité
- **MINOR** (`x.Y.0`) : ajout de fonctionnalité, nouveau module IaC, nouveau playbook
- **PATCH** (`x.y.Z`) : correction de bug, amélioration docs, fix CI

---

## Politique de support

- **Mode** : best-effort / communauté
- **Issues** : bienvenues via les [templates GitHub](https://github.com/BUTINFO57/gaston-infra/issues/new/choose)
- **Contributions** : voir [CONTRIBUTING.md](../../CONTRIBUTING.md)
- **Sécurité** : signalement via [GitHub Private Vulnerability Reporting](https://github.com/BUTINFO57/gaston-infra/security/advisories/new)

---

## Procédure de contribution

1. Fork ou branche depuis `main`
2. Nommer les commits en [Conventional Commits FR](../../CONTRIBUTING.md)
3. Ouvrir une PR vers `main`
4. Attendre CI verte (9 jobs)
5. Review + merge

---

## Publier une release

```bash
# 1. Merger la PR dans main
gh pr merge <PR_NUMBER> --merge

# 2. Tagger
git checkout main && git pull --ff-only
git tag -a vX.Y.Z -m "vX.Y.Z — Description courte"
git push origin vX.Y.Z

# 3. Créer la release GitHub
gh release create vX.Y.Z --title "vX.Y.Z — Description" --notes "..."
```

---

## Gates CI (9 jobs)

| Job | Outil | Périmètre |
|-----|-------|-----------|
| Markdown Lint | markdownlint-cli2 | `**/*.md` |
| Link Check | lychee (offline) | `**/*.md` |
| Secret Scan | TruffleHog | Historique git (verified only) |
| Mermaid Validation | mmdc | Diagrammes extraits des `.md` |
| Terraform Validate | `terraform fmt` + `validate` | `iac/terraform/{lab,prod}` |
| YAML Lint | yamllint | Tous les `.yml` / `.yaml` |
| Ansible Lint | ansible-lint | `automation/ansible/` |
| ShellCheck | shellcheck | `tools/*.sh`, `iac/terraform/scripts/*.sh` |
| Policy Check | grep + exit 1 | Interdire `<PLACEHOLDER>` hors exemptions |

### Lancer localement

```bash
make validate          # Tous les linters (markdownlint + yamllint)
make docs              # Liens + Mermaid
shellcheck tools/*.sh  # Scripts shell
cd iac/terraform/lab && terraform init -backend=false && terraform validate
cd ../prod && terraform init -backend=false && terraform validate
```
