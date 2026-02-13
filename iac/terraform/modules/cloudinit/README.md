# Module Cloud-Init — Snippets Proxmox

Ce module génère des fichiers cloud-init (snippets) dans le stockage Proxmox.

Utile pour personnaliser la configuration au-delà de ce que permet le bloc
`initialization` du provider (ex: scripts de post-installation, clés GPG,
montages NFS).

## Variables

| Variable | Type | Description |
|:---------|:-----|:------------|
| `node_name` | `string` | Nœud Proxmox cible |
| `datastore_id` | `string` | Datastore pour les snippets (défaut: `local`) |
| `filename` | `string` | Nom du fichier snippet |
| `content` | `string` | Contenu YAML du snippet |

## Outputs

| Output | Description |
|:-------|:------------|
| `file_id` | ID du fichier dans Proxmox |
