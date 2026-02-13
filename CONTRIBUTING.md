# Contribuer à gaston-infra

Merci de vouloir contribuer !

## Pour commencer

1. Forker le dépôt
2. Créer une branche : `git checkout -b feat/ma-fonctionnalite`
3. Commits en [Conventional Commits](https://www.conventionalcommits.org/) **en français**
4. Pousser et ouvrir une Pull Request

## Convention de commits

Messages en **français**, format Conventional Commits :

```text
<type>(<portée>): <description en français>

Types : feat, fix, docs, chore, refactor, test, ci
Portées : docs, runbook, ansible, terraform, iac, powershell, ci, repo, architecture, configs
```

Exemples :

- `feat(iac): ajouter module Terraform pour VMs Proxmox`
- `fix(runbook): corriger IP AD-DC02 dans le plan réseau`
- `docs(quickstart): ajouter parcours LAB en 60 minutes`
- `chore(ci): ajouter terraform validate en CI`

## Règles de Pull Request

1. **Une PR = un sujet** (pas de PR fourre-tout)
2. Titre au format Conventional Commit
3. Description avec le template fourni
4. Tous les checks CI doivent passer (lint, liens, secrets)
5. Pas de secrets, pas de `<PLACEHOLDER>` non documenté
6. CHANGELOG mis à jour si la modification est visible

## Vérifications de qualité

Avant de soumettre, exécuter localement :

```bash
make validate            # lint + docs
make lint-tf             # formatage Terraform
make lint-ansible        # lint Ansible
make lint-sh             # shellcheck
```

Ou vérifier manuellement :

- [ ] Le lint Markdown passe (`markdownlint-cli2 "**/*.md"`)
- [ ] Les liens sont valides (`bash tools/validate-links.sh`)
- [ ] Les diagrammes Mermaid s'affichent (`bash tools/validate-mermaid.sh`)
- [ ] Le formatage Terraform est correct (`bash iac/terraform/scripts/fmt.sh`)
- [ ] Aucun secret ni mot de passe réel
- [ ] Tous les placeholders utilisent le format `<PLACEHOLDER>`
- [ ] Les TODO suivent le format `TODO[XXX]` et sont dans le registre (`docs/index.md`)

## Structure des fichiers

- **iac/** — Infrastructure as Code (Terraform)
- **automation/** — Configuration management (Ansible, PowerShell)
- **docs/** — Documentation utilisateur
- **runbooks/** — Procédures pas-à-pas exécutables
- **configs/** — Fichiers modèles (suffixe `.template`)
- **examples/** — Fichiers `.example`, jamais de vrais configs
- **tools/** — Scripts de validation et utilitaires

## Signaler un problème

Utilisez les [modèles de tickets](.github/ISSUE_TEMPLATE/) pour les bugs et les demandes de fonctionnalités.
