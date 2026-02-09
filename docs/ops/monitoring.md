# 📡 Monitoring — Checkmk

## Architecture

| Composant | Détail |
|:----------|:-------|
| **Solution** | Checkmk Raw Edition 2.4 |
| **Hôte** | MON-01 (`192.168.10.114`) |
| **Site** | `gaston` |
| **URL** | `https://192.168.10.114/gaston` |
| **Admin** | `cmkadmin` |

## Hôtes supervisés (12)

| Hostname | IP | Agent Type |
|:---------|:---|:-----------|
| pve1 | 192.168.10.11 | SNMP + Agent |
| pve2 | 192.168.10.12 | SNMP + Agent |
| pve03 | 192.168.10.50 | SNMP + Agent |
| pfSense | 192.168.10.1 | SNMP only |
| AD-DC01 | 192.168.10.10 | Linux Agent |
| AD-DC02 | 192.168.10.9 | Linux Agent |
| FS01 | 192.168.10.111 | Windows Agent |
| MAIL-01 | 192.168.10.115 | Linux Agent |
| rp-prod01 | 192.168.20.106 | Linux Agent |
| web-wp01 | 192.168.20.108 | Linux Agent |
| maria-prod01 | 192.168.20.105 | Linux Agent |
| PBS | 192.168.30.100 | Linux Agent |

> TODO[003]: Confirmer l'IP de PBS pour le monitoring (`.10.112` monitoring NIC vs `.30.100` data NIC) | Où: docs/ops/monitoring.md | Attendu: 1 IP | Exemple: `192.168.30.100`

## Déployer un agent Linux

```bash
wget http://192.168.10.114/gaston/check_mk/agents/check-mk-agent_2.4.0-1_all.deb
dpkg -i check-mk-agent_*.deb
cmk-agent-ctl register --hostname $(hostname) \
  --server mon-01.gaston.local --site gaston \
  --user cmkadmin --password '<PLACEHOLDER>' --trust-cert
```

## Déployer un agent Windows (FS01)

1. Télécharger depuis `https://192.168.10.114/gaston/check_mk/agents/`
2. Installer le MSI
3. Enregistrer via `cmk-agent-ctl.exe`

## Opérations courantes

### Réinitialiser le mot de passe admin

```bash
omd su gaston -- cmk-passwd cmkadmin
```

### Redémarrer le site

```bash
omd restart gaston
```

### Sauvegarder la configuration

```bash
omd backup gaston /tmp/gaston-backup.tar.gz
```

### Tester un agent

```bash
cmk -d <hostname>
```

## Alertes recommandées (post-J0)

- CPU > 90% pendant 5 min
- Disque > 85%
- Service down
- Backup PBS échoué
- Certificat TLS expire dans < 30 jours
