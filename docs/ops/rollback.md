# 🔄 Rollback — Plan de retour arrière

## Par bloc

| Bloc | Procédure | Durée |
|:-----|:----------|:-----:|
| **Switch SG350** | Maintenir RESET 10 s → factory reset. Reconfigurer. | 15 min |
| **pfSense** | Restaurer XML : `Diagnostics > Backup & Restore`. Ou réinstaller USB. | 20 min |
| **Cluster PVE** | `pvecm delnode <node>` depuis nœud sain + `pvecm expected 2`. | 10 min |
| **AD-DC01** | Restaurer VM PBS. Ou re-provisionner `samba-tool domain provision`. | 30 min |
| **AD-DC02** | Supprimer et re-joindre `samba-tool domain join`. | 20 min |
| **FS01** | Restaurer VM PBS. Ou re-join domaine + recréer partages. | 20 min |
| **MAIL-01** | `docker compose down && docker compose up -d`. Ou restaurer VM PBS. | 15 min |
| **MON-01** | Restaurer VM PBS. Ou `omd restore gaston /path/backup.tar.gz`. | 20 min |
| **PBS** | Réinstaller PBS. Données persistent sur `/mnt/datastore/backup-main`. | 20 min |
| **Prod Web** | Restaurer les 3 VMs depuis PBS. | 30 min |
| **NFS Storage** | `systemctl restart nfs-kernel-server` sur PVE03, `exportfs -ra`. | 5 min |

## Procédures détaillées

### pfSense — Restaurer config XML

```text
1. Diagnostics > Backup & Restore
2. Restore Configuration → sélectionner le fichier XML
3. Appliquer → redémarrage automatique
```

### Cluster PVE — Retirer un nœud défaillant

```bash
# Depuis un nœud SAIN
pvecm delnode <nom-du-noeud-mort>
pvecm expected 2    # Si passage temporaire à 2 nœuds
```

### Mailcow — Restart complet

```bash
cd /opt/mailcow-dockerized
docker compose down
docker compose up -d
docker compose ps    # Vérifier 15 containers Up
```

### NFS — Redémarrer l'export

```bash
# Sur PVE03
exportfs -v                           # Vérifier les exports
systemctl restart nfs-kernel-server
exportfs -ra                          # Re-appliquer
```

## Principes

1. **Toujours sauvegarder la config avant modification** (pfSense XML, PVE snapshot)
2. **Tester le rollback en LAB** avant de le faire en PROD
3. **Documenter ce qui a été fait** pour éviter de reproduire l'erreur
4. **Un rollback n'est pas un échec** — c'est une procédure normale d'exploitation
