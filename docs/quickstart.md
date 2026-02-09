# ⚡ Démarrage rapide — 5 minutes

## 1. Cloner le dépôt

```bash
git clone https://github.com/butinfoia-alt/gaston-infra.git
cd gaston-infra
```

## 2. Choisir votre parcours

### 🧪 J'ai 1 seul PC / serveur

➡️ **[Guide LAB](lab/overview.md)**

- 1 machine avec 16+ Go RAM
- Proxmox installé (ou à installer)
- VLANs virtuels via bridges
- Pas de HA réel, même architecture logique
- **Temps : ≈ 4 h**

### 🏭 J'ai 3 serveurs + switch + pfSense

➡️ **[Guide PROD](prod/overview.md)**

- 3 serveurs physiques (HP DL360 Gen10+ ou équivalent)
- 1 PC dédié pfSense (2 cartes réseau minimum)
- 1 switch Cisco SG350-28
- **Temps : ≈ 10 h (1 journée)**

## 3. Préparer les secrets

```bash
cp examples/secrets.env.example .env
# Éditer .env avec vos mots de passe réels
# NE JAMAIS commiter ce fichier
```

## 4. Vérifier les prérequis

| Prérequis | LAB | PROD |
|:----------|:---:|:----:|
| ISO Proxmox VE 9.0 | ✅ | ✅ |
| ISO Debian 12/13 | ✅ | ✅ |
| ISO pfSense CE 24.0 | ✅ | ✅ |
| ISO Windows Server 2022 | ✅ | ✅ |
| 16+ Go RAM | ✅ | ✅ (par serveur) |
| 2 cartes réseau sur pfSense | ❌ (VM) | ✅ |
| Switch managé | ❌ (bridges) | ✅ |

## 5. Suivre le runbook

Une fois l'environnement prêt :

- **LAB** → [single-host-proxmox.md](lab/single-host-proxmox.md)
- **PROD** → [day0-runbook.md](prod/day0-runbook.md) ou directement le [runbook complet](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md)
