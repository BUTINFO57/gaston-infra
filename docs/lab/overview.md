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

## Checklist LAB express (~30 minutes de préparation)

Avant de démarrer, cochez chaque élément :

- [ ] PC avec 16+ Go RAM, 256+ Go SSD, 1 port Ethernet
- [ ] Clé USB ≥ 2 Go (pour l'ISO Proxmox)
- [ ] ISO **Proxmox VE 9.x** téléchargé : <https://www.proxmox.com/en/downloads>
- [ ] ISO **Debian 12 netinst** téléchargé : <https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/>
- [ ] ISO **pfSense CE 2.7** téléchargé : <https://www.pfsense.org/download/>
- [ ] Connexion Internet (pour `apt`, Docker pulls, Mailcow, Checkmk)
- [ ] Ce guide ouvert dans un onglet navigateur

### Ordre de déploiement LAB

```text
┌─────────────────────────────────────────────────┐
│  1. Installer Proxmox VE sur le PC              │  ~10 min
│  2. Créer les bridges VLAN-aware (vmbr0)        │   ~5 min
│  3. Créer + configurer la VM pfSense            │  ~15 min
│  4. Créer les VMs (DC01, FS01, MAIL, MON, PBS)  │  ~10 min/VM
│  5. Suivre le runbook J0 à partir de §4.4       │  ~4 heures
└─────────────────────────────────────────────────┘
```

### Ce qui est simulé en LAB

| Composant PROD | Simulation LAB | Fonctionnel ? |
|:---------------|:---------------|:-------------:|
| Switch SG350-28 (802.1Q) | Bridge `vmbr0` VLAN-aware | ✅ Identique |
| Cluster 3 nœuds + HA | 1 nœud, pas de HA | ⚠️ Réduit |
| NFS partagé (PVE03) | Stockage local | ⚠️ Pas de migration live |
| pfSense 2 NIC physiques | pfSense 2 vNIC | ✅ Identique |
| AD-DC02 réplica | Optionnel (économie RAM) | ⚠️ Optionnel |
| PBS VLAN 30 isolé | VM même hôte, VLAN tag 30 | ✅ Identique |

> 💡 **L'essentiel fonctionne à l'identique** : VLANs, routage pfSense, AD, DNS, partages SMB, Mailcow, Checkmk, PBS, stack web. Seuls le clustering et la HA ne sont pas reproductibles sur un seul hôte.
