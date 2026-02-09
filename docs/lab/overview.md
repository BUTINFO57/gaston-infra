# 🧪 LAB — Vue d'ensemble

## Concept

Reproduire l'architecture complète de *Les Saveurs de Gaston* sur **un seul hôte Proxmox**.
L'objectif est d'apprendre, tester et valider chaque composant sans matériel dédié.

## Ce qui change par rapport à PROD

| Aspect | PROD (3 nœuds) | LAB (1 hôte) | Impact |
|:-------|:----------------|:-------------|:-------|
| **Cluster Proxmox** | 3 nœuds physiques | 1 seul nœud | Pas de HA Manager, pas de failover |
| **Quorum** | 3 votes, tolérance N-1 | N/A | Pas de résilience cluster |
| **NFS partagé** | PVE03 sert NFS aux 2 autres | Stockage local | Migration live impossible |
| **pfSense** | PC physique dédié (2 NIC) | VM dans Proxmox (2 vNIC) | Fonctionne identiquement |
| **Switch SG350** | Switch physique, trunks réels | Linux bridges VLAN-aware | VLANs identiques, pas de 802.1Q physique |
| **AD-DC02 (réplica)** | VM séparée, réplication | Optionnel (économie RAM) | Pas de redondance AD |
| **PBS (VLAN 30)** | VM isolée sur VLAN dédié | VM sur même hôte | Isolation logique conservée |

## Ressources minimales

| Composant | RAM | Disque | vCPU |
|:----------|:---:|:------:|:----:|
| Proxmox host | — | 256 Go SSD | — |
| pfSense VM | 2 Go | 16 Go | 1 |
| AD-DC01 | 4 Go | 32 Go | 2 |
| FS01 | 4 Go | 50 Go | 2 |
| MAIL-01 | 6 Go | 50 Go | 2 |
| MON-01 | 4 Go | 32 Go | 2 |
| PBS | 2 Go | 100 Go | 1 |
| maria-prod01 | 2 Go | 20 Go | 1 |
| web-wp01 | 2 Go | 20 Go | 1 |
| rp-prod01 | 1 Go | 16 Go | 1 |
| **Total** | **~27 Go** | **~336 Go** | **13** |

> 💡 Avec 32 Go de RAM, c'est confortable. Avec 16 Go, supprimer DC02 et réduire les RAM (Mailcow 4 Go min, FS01 2 Go).

## Guides détaillés

1. **[Installation single-host Proxmox](single-host-proxmox.md)** — Installer PVE, créer les bridges VLAN
2. **[Networking & VLANs](networking-vlans.md)** — Configurer les VLANs virtuels sans switch physique

## Ensuite

Une fois l'hôte prêt, suivre le [runbook J0](../prod/day0-runbook.md) en ignorant les étapes :

- §4.1 (Switch SG350) → remplacé par les bridges
- §4.3.3–4.3.6 (Cluster + NFS) → pas applicable en mono-nœud
