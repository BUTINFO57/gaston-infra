# Guide de maintenance

Procédures standard pour maintenir le dépôt `gaston-infra`.

---

## Créer une branche

```bash
git checkout main
git pull --ff-only
git checkout -b <type>/<description-courte>
```

**Types de branches** :

| Préfixe | Usage |
|---------|-------|
| `feat/` | Nouvelle fonctionnalité |
| `fix/` | Correction de bug |
| `docs/` | Documentation uniquement |
| `chore/` | Maintenance, CI, outillage |
| `refactor/` | Restructuration sans changement fonctionnel |

---

## Nommer les commits

Format **Conventional Commits** en français :

```text
<type>(<portée>): <description courte en français>
```

| Type | Quand |
|------|-------|
| `feat` | Ajout de fonctionnalité |
| `fix` | Correction de bug |
| `docs` | Documentation uniquement |
| `style` | Formatage, sans changement de logique |
| `refactor` | Restructuration interne |
| `chore` | Maintenance, CI, tooling |
| `test` | Ajout ou modification de tests |

**Portées courantes** : `iac`, `ansible`, `ci`, `docs`, `tools`, `pfsense`, `changelog`

**Exemples** :

```text
feat(ansible): ajouter rôle GLPI
fix(iac): corriger placement PBS sur PVE03
docs(ops): mettre à jour procédure de sauvegarde
chore(ci): ajouter job trivy scan
```

---

## Ouvrir une PR

1. Pousser la branche :

   ```bash
   git push -u origin <branche>
   ```

2. Créer la PR :

   ```bash
   gh pr create --base main --title "<type>: description courte" --body "..."
   ```

3. Le corps de la PR doit inclure :
   - **Objectif** : pourquoi ce changement
   - **Changements** : liste des modifications
   - **Impact** : ce qui change pour l'utilisateur/déployeur
   - **Comment valider** : commandes ou étapes de test

---

## Valider avant merge

Tous les checks doivent être verts (9 jobs CI) :

```bash
# Linters
make validate
shellcheck tools/*.sh

# IaC
cd iac/terraform/lab && terraform init -backend=false && terraform validate
cd ../prod && terraform init -backend=false && terraform validate

# Docs
make docs  # liens + Mermaid
```

---

## Merger

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

- Toujours utiliser `--merge` (pas de squash ni rebase sur main)
- Pas de réécriture d'historique sur `main`

---

## Tagger et publier une release

```bash
# 1. Se placer sur main à jour
git checkout main && git pull --ff-only

# 2. Créer le tag annoté
git tag -a vX.Y.Z -m "vX.Y.Z — Description courte"
git push origin vX.Y.Z

# 3. Créer la release GitHub
gh release create vX.Y.Z \
  --title "vX.Y.Z — Description courte" \
  --notes "## Changements\n\n- ..."
```

**Versionnage** : voir [STATUS.md](STATUS.md) pour la politique SemVer.

---

## Règles anti-secrets

### Obligatoire

- **Ne jamais committer** de mot de passe, token, clé API ou clé privée
- Utiliser `<PLACEHOLDER>` dans les fichiers de configuration
- Les fichiers contenant des secrets réels doivent être dans `.gitignore`
- Extensions interdites dans git : `.tfstate`, `.tfvars`, `.env` (hors `.example`)

### Vérification

```bash
# Scan local
grep -rn 'BEGIN.*PRIVATE KEY\|password=\|token=\|apikey=' . \
  --include='*.md' --include='*.yml' --include='*.tf' --include='*.sh' \
  | grep -v PLACEHOLDER | grep -v example

# CI vérifie automatiquement via TruffleHog (secrets vérifiés uniquement)
```

### En cas de fuite

1. Révoquer immédiatement le secret compromis
2. Signaler via [GitHub Private Vulnerability Reporting](https://github.com/BUTINFO57/gaston-infra/security/advisories/new)
3. Nettoyer l'historique git si nécessaire (`git filter-repo`)
