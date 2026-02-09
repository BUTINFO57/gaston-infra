# Contribuer à gaston-infra

Merci de vouloir contribuer ! 🎉

## Pour commencer

1. Forker le dépôt
2. Créer une branche : `git checkout -b feat/ma-fonctionnalite`
3. Commits en [Conventional Commits](https://www.conventionalcommits.org/) :
   - `feat(docs): ajouter guide réseau LAB`
   - `fix(runbook): corriger IP AD-DC02`
   - `chore(ci): ajouter validation mermaid`
4. Pousser et ouvrir une Pull Request

## Convention de commits

```text
<type>(<portée>): <description en français>

Types : feat, fix, docs, chore, refactor, test, ci
Portées : docs, runbook, ansible, powershell, ci, repo, architecture, configs
```

## Vérifications de qualité

Avant de soumettre :

- [ ] Le lint Markdown passe (`markdownlint **/*.md`)
- [ ] Tous les liens sont valides (`lychee --offline **/*.md`)
- [ ] Les diagrammes Mermaid s'affichent (`tools/validate-mermaid.sh`)
- [ ] Aucun secret ni mot de passe réel
- [ ] Tous les placeholders utilisent le format `<PLACEHOLDER>`
- [ ] Les TODO suivent le format `TODO[XXX]`

## Structure des fichiers

- **docs/** — Documentation utilisateur
- **runbooks/** — Procédures pas-à-pas exécutables
- **configs/** — Fichiers modèles (suffixe `.template`)
- **automation/** — Scripts et playbooks
- **examples/** — Fichiers `.example`, jamais de vrais configs

## Signaler un problème

Utilisez les [modèles de tickets](.github/ISSUE_TEMPLATE/) pour les bugs et les demandes de fonctionnalités.
