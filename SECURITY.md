# Politique de sécurité

## ⚠️ Dépôt public

Ce dépôt est **public** et fait partie d'un projet étudiant (SAÉ).
Il documente une architecture d'infrastructure réelle mais **ne doit contenir** :

- Aucun mot de passe, clé API ou token réel
- Aucune adresse IP de systèmes en production réelle
- Aucune donnée personnelle (noms, emails, téléphones)
- Aucun certificat ou identifiant interne

## Signaler une vulnérabilité

Si vous trouvez des données sensibles qui ne devraient pas être publiques :

1. **N'ouvrez PAS de ticket public.**
2. Utilisez l'onglet **Security → Report a vulnerability** du dépôt GitHub
   pour signaler le problème de manière privée (fonctionnalité « Private
   vulnerability reporting » activée par GitHub par défaut sur les dépôts
   publics).
3. Si cette fonctionnalité n'est pas disponible, ouvrez un ticket en
   indiquant uniquement « Donnée sensible détectée » sans révéler le contenu.
4. Nous répondrons sous 48 heures et supprimerons les données sensibles.

## Gestion des identifiants

- Tous les identifiants de ce dépôt utilisent des marqueurs `<PLACEHOLDER>`.
- Les secrets réels doivent être stockés dans un gestionnaire de mots de passe (KeePassXC, Bitwarden, etc.).
- Voir `examples/secrets.env.example` pour le format attendu.
- Voir `docs/ops/secrets.md` pour le guide complet de gestion des secrets en local.
- **Ne jamais** commiter de fichiers `.env`, `.tfvars`, `.tfstate` — ils sont dans `.gitignore`.

## Garde-fous automatiques

| Contrôle | Outil | Où |
|:---------|:------|:---|
| Scan de secrets | TruffleHog | CI (`.github/workflows/ci.yml`) |
| Politique placeholders | Job `policy` | CI (interdit `<PLACEHOLDER>` sur `main` hors `*.example` et templates) |
| Gitignore | `.gitignore` | Protège `*.tfstate`, `*.tfvars`, `*.env`, `secrets/`, `*.key`, `*.pem` |

## Versions supportées

| Version | Supportée |
|:--------|:----------|
| v1.x    | ✅ Actuelle |
| < v1.0  | ❌ Pré-release |
