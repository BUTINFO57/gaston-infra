# pfSense — Export de configuration

## Procédure de sauvegarde

1. `Diagnostics > Backup & Restore`
2. `Download Configuration as XML`
3. Enregistrer sous `config-pfSense.gaston.local.xml`

## Quand sauvegarder

- **Avant** toute modification majeure (règles FW, VPN, VLAN)
- **Après** chaque section de déploiement terminée
- **En fin de journée** (achèvement J0)

## Procédure de restauration

1. `Diagnostics > Backup & Restore`
2. `Restore Configuration` → sélectionner le fichier XML
3. Appliquer → redémarrage automatique

## Important

- Le fichier XML contient des **mots de passe hachés** et des **certificats**
- **Ne jamais** commiter le fichier XML réel dans ce dépôt
- Le stocker dans un emplacement **sécurisé, hors ligne** (clé USB chiffrée, gestionnaire de mots de passe)
