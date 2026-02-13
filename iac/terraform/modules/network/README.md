# Module Network — Bridges et VLANs Proxmox

Ce module gère la création de bridges réseau Linux sur un nœud Proxmox.

> **Note** : En général, les bridges Proxmox (`vmbr0`, `vmbr1`, etc.) sont
> configurés manuellement lors de l'installation. Ce module est utile pour
> documenter et reproduire la configuration réseau de manière déclarative.

## Variables

| Variable | Type | Description |
|:---------|:-----|:------------|
| `node_name` | `string` | Nœud Proxmox cible |
| `bridges` | `map(object)` | Bridges à créer |
