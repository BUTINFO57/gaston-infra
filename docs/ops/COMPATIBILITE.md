# Matrice de compatibilité

## Systèmes d'exploitation

| OS | Version testée | Rôle |
|----|---------------|------|
| Proxmox VE | 8.x / 9.0 | Hyperviseur (3 nœuds PROD, 1 nœud LAB) |
| Debian | 12 (Bookworm) | VMs Linux (cloud-init) |
| Windows Server | 2022 Core | FS01 (partages SMB) |
| pfSense CE | 24.0 | Pare-feu / routeur / VPN |

## Dépendances CLI

| Outil | Version minimale | Usage |
|-------|-----------------|-------|
| Terraform | ≥ 1.5 | Provisioning VMs Proxmox |
| Ansible | ≥ 2.15 | Configuration des services |
| ansible-lint | ≥ 24.x | Lint des playbooks/rôles |
| yamllint | ≥ 1.30 | Lint YAML |
| markdownlint-cli2 | ≥ 0.12 | Lint Markdown |
| shellcheck | ≥ 0.9 | Analyse statique des scripts shell |
| mmdc (mermaid-cli) | ≥ 10.x | Validation des diagrammes Mermaid |
| lychee | ≥ 0.14 | Vérification des liens |
| git | ≥ 2.40 | Gestion de version |
| gh (GitHub CLI) | ≥ 2.x | PR, releases, labels |
| make | ≥ 4.x | Orchestration des tâches |

## Provider Terraform

| Provider | Source | Version |
|----------|--------|---------|
| bpg/proxmox | `registry.terraform.io/bpg/proxmox` | `>= 0.50` |

> **Attention** : le provider est `bpg/proxmox`, **pas** Telmate.
> Les variables d'environnement sont `PROXMOX_VE_*` (et non `PM_*`).

## Limites connues — LAB vs PROD

| Aspect | LAB | PROD |
|--------|-----|------|
| Nœuds Proxmox | 1 | 3 (cluster HA) |
| Haute disponibilité | Non | Oui (HA Manager, RTO < 90 s) |
| Stockage partagé | Local uniquement | NFS v4.2 partagé |
| VPN | Optionnel | OpenVPN + LDAPS |
| Sauvegarde PBS | Optionnelle | Obligatoire (VLAN 30 isolé) |
| Performances | Ressources réduites | Dimensionnement réel |

## Hors périmètre

Les éléments suivants sont **volontairement exclus** du dépôt :

- **Données de production** : aucune base de données, fichier utilisateur ou backup réel
- **Secrets réels** : tous les mots de passe utilisent `<PLACEHOLDER>` ou des fichiers `.example`
- **Monitoring SaaS** : pas d'intégration cloud (tout est on-premise)
- **Multi-site** : architecture mono-site uniquement
- **Conteneurisation applicative** : seul Mailcow utilise Docker (par conception de l'éditeur)
- **IPv6** : non configuré (IPv4 uniquement sur les 3 VLANs)
