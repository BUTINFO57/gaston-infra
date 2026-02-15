# 🔐 Gestion des secrets en local

## Principe

Ce dépôt ne contient **aucun secret**. Tous les identifiants sensibles
utilisent des marqueurs `<PLACEHOLDER>` ou des fichiers `.example`.

Ce guide explique comment gérer les secrets en local sans outils payants.

## Méthode recommandée : fichier `.env` + gestionnaire de mots de passe

### 1. Copier le fichier exemple

```bash
cp examples/secrets.env.example .env
```

### 2. Remplir les valeurs

Ouvrir `.env` avec votre éditeur et remplacer chaque ligne vide par la
valeur réelle. Générer des mots de passe forts :

```bash
# Générer un mot de passe aléatoire de 32 caractères
openssl rand -base64 32
# ou
python3 -c "import secrets; print(secrets.token_urlsafe(32))"
```

### 3. Ne jamais commiter

Le fichier `.env` est protégé par `.gitignore`. Vérifier :

```bash
git status  # .env ne doit PAS apparaître
```

### 4. Sauvegarder les secrets

Stocker une copie chiffrée des secrets dans un gestionnaire de mots de passe :

| Outil | Licence | Plateforme |
|:------|:--------|:-----------|
| **KeePassXC** | Libre (GPLv3) | Windows, macOS, Linux |
| **Bitwarden** | Libre (AGPLv3) | Toutes (cloud ou self-hosted) |
| **pass** | Libre (GPLv2) | Linux, macOS |

## Secrets Terraform

Les identifiants Proxmox sont passés via **variables d'environnement** :

```bash
# Option 1 : Token API (recommandé)
export PROXMOX_VE_API_TOKEN="terraform@pam!iac=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Option 2 : Utilisateur / mot de passe
export PM_USER="root@pam"
export PM_PASS="votre-mot-de-passe"
```

Les fichiers `terraform.tfvars` sont aussi dans `.gitignore`.

### Workflow sécurisé

```bash
# Charger les secrets depuis .env avant d'exécuter Terraform
set -a; source .env; set +a

cd iac/terraform/lab
terraform plan
```

## Secrets Ansible

Les mots de passe Ansible peuvent être gérés via :

### Option A : Variables en ligne de commande

```bash
ansible-playbook -i inventories/lab.ini playbooks/base-linux.yml \
  --extra-vars "root_password=$(cat .env | grep MARIADB_ROOT_PASSWORD | cut -d= -f2)"
```

### Option B : Ansible Vault (fichier chiffré)

```bash
# Créer un vault
ansible-vault create automation/ansible/group_vars/all/vault.yml
# Éditer
ansible-vault edit automation/ansible/group_vars/all/vault.yml
# Exécuter avec le vault
ansible-playbook -i inventories/lab.ini playbooks/mariadb.yml --ask-vault-pass
```

> Le fichier `vault.yml` est dans `.gitignore`.

## Vérification anti-secret

Avant chaque commit, vérifier qu'aucun secret n'est présent :

```bash
# Recherche rapide
grep -rn "password\|secret\|token\|key" . \
  --include="*.tf" --include="*.yml" --include="*.sh" \
  | grep -v "PLACEHOLDER" | grep -v "example" | grep -v ".gitignore"

# Scan avec TruffleHog (utilisé aussi en CI)
docker run --rm -v "$(pwd):/repo" trufflesecurity/trufflehog filesystem /repo
```

## Liens

- [SECURITY.md](../../SECURITY.md) — Politique de sécurité
- [examples/secrets.env.example](../../examples/secrets.env.example) — Template secrets
- [iac/terraform/README.md](../../iac/terraform/README.md) — Authentification Proxmox
