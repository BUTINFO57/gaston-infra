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
2. Contactez les mainteneurs en privé :
   - TODO[002]: Adresse email de contact sécurité | Où: SECURITY.md | Attendu: email | Exemple: securite@example.com
3. Nous répondrons sous 48 heures et supprimerons les données sensibles.

## Gestion des identifiants

- Tous les identifiants de ce dépôt utilisent des marqueurs `<PLACEHOLDER>`.
- Les secrets réels doivent être stockés dans un gestionnaire de mots de passe (KeePassXC, Bitwarden, etc.).
- Voir `examples/secrets.env.example` pour le format attendu.
- **Ne jamais** commiter de fichiers `.env` — ils sont dans `.gitignore`.

## Versions supportées

| Version | Supportée |
|:--------|:----------|
| v1.x    | ✅ Actuelle |
| < v1.0  | ❌ Pré-release |
