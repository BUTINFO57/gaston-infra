# 📚 Documentation — gaston-infra

Bienvenue dans la documentation du projet **Les Saveurs de Gaston**.

## Navigation

| Guide | Description | Public |
|:------|:------------|:-------|
| [Démarrage rapide](quickstart.md) | Démarrer en 5 minutes | Tout le monde |
| [LAB — mono-hôte](lab/overview.md) | Déployer sur 1 seul PC | Étudiants, homelab |
| [PROD — 3 nœuds](prod/overview.md) | Déploiement complet J0 | Production |
| [Architecture](architecture/diagrams.md) | Schémas, plan IP, flux | Référence |
| [Opérations](ops/backup.md) | Sauvegarde, supervision, rollback | Ops / Admin |

## Parcours recommandé

```text
1. quickstart.md        → comprendre le projet en 5 min
2. lab/overview.md      → choisir son chemin (LAB ou PROD)
3. lab/ ou prod/        → suivre le guide pas à pas
4. ops/                 → opérations quotidiennes
```

## Runbooks

Les procédures exécutables sont dans [`/runbooks/`](../runbooks/) :

- [Runbook J0 complet](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md)
- [Checklist exécutive 20 min](../runbooks/RUNBOOK-EXEC-20MIN.md)

---

## Registre des décisions techniques

Les contradictions entre documents sources ont été tranchées comme suit :

| Sujet | Décision | Justification |
|:------|:---------|:--------------|
| IPs VLAN 20 (PROD) | `.105` / `.106` / `.108` | Aligné sur les règles pfSense en place |
| PBS NIC | 1 NIC — `192.168.30.100` (VLAN 30) | Config la plus simple ; le monitoring passe par le routage pfSense VLAN 30→10 |
| GLPI OS | Debian 12 + GLPI 10.0 (estimé) | Non documenté dans les sources ; valeur par défaut raisonnable |
| Auth Container LDAP (VPN) | `OU=Users,OU=_Tier-2,DC=gaston,DC=local` | Cohérent avec la structure OU Tiering déployée |
| Communauté SNMP switch | `checkmk_gaston_ro` | Valeur neutre choisie pour le monitoring |
| Interface pfSense | `em0` (WAN) / `em1` (LAN) | Noms par défaut FreeBSD, à adapter au matériel réel |

> 💡 Ces décisions concernent la documentation. En déploiement réel, adapter les valeurs
> au matériel et à l'environnement. Les marqueurs `<PLACEHOLDER>` dans les fichiers de
> configuration indiquent les valeurs à fournir par l'utilisateur (mots de passe, clés, etc.).

---

## Fichiers de configuration

Les templates et documents de configuration sont dans [`/configs/`](../configs/) :

### pfSense

| Fichier | Description |
|:--------|:------------|
| [openvpn.md](../configs/pfsense/openvpn.md) | Paramètres OpenVPN + auth LDAP |
| [rules.md](../configs/pfsense/rules.md) | Règles firewall par VLAN |
| [aliases.md](../configs/pfsense/aliases.md) | Alias réseau pfSense |
| [config-export.md](../configs/pfsense/config-export.md) | Procédure d'export XML |

### Samba AD

| Fichier | Description |
|:--------|:------------|
| [provision.sh.template](../configs/samba/provision.sh.template) | Script de provisioning AD-DC01 |
| [ou-groups.sh.template](../configs/samba/ou-groups.sh.template) | Création OUs et groupes Tier-0/1/2 |

### NGINX / UFW

| Fichier | Description |
|:--------|:------------|
| [rp-prod01.conf.template](../configs/nginx/rp-prod01.conf.template) | vhost NGINX reverse proxy |
| [ufw-web.template](../configs/ufw/ufw-web.template) | Règles UFW pour web-wp01 |
| [ufw-db.template](../configs/ufw/ufw-db.template) | Règles UFW pour maria-prod01 |
