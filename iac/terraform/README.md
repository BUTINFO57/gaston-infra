# 🏗️ Terraform — Provisioning IaC

## Vue d'ensemble

Ce dossier contient le code Terraform pour provisionner les machines virtuelles
et le réseau dans Proxmox VE, pour le projet **Les Saveurs de Gaston**.

```text
iac/terraform/
├── modules/         # Modules réutilisables
│   ├── vm/          # Création de VM avec cloud-init
│   ├── network/     # Bridges et VLANs Proxmox
│   └── cloudinit/   # Snippets cloud-init
├── lab/             # Environnement LAB mono-hôte
├── prod/            # Environnement PROD multi-nœuds
└── scripts/         # Scripts de validation
```

## Provider Proxmox

Ce projet utilise le provider Terraform **bpg/proxmox** (maintenu activement).

- **Registry** : <https://registry.terraform.io/providers/bpg/proxmox/latest>
- **Source** : <https://github.com/bpg/terraform-provider-proxmox>

> **Note** : Le fichier `versions.tf` ne fige pas de version patch pour
> éviter l'obsolescence. Seule la version mineure minimale est contrainte.
> Vérifiez la dernière version disponible avant le déploiement.

## Prérequis

| Outil | Version minimale | Installation |
|:------|:-----------------|:-------------|
| Terraform | ≥ 1.6 | [terraform.io/downloads](https://developer.hashicorp.com/terraform/install) |
| Proxmox VE | ≥ 8.0 | Déjà installé sur le(s) nœud(s) |
| Template cloud-init | Debian 12/13 | Voir section ci-dessous |

## Authentification Proxmox

Le provider se connecte à l'API Proxmox. **Ne jamais stocker les identifiants
dans les fichiers `.tf` ou `.tfvars`.**

### Méthode recommandée : variables d'environnement

```bash
# Le endpoint est défini dans terraform.tfvars (variable pm_api_url)
# L'authentification se fait via variables d'environnement du provider bpg/proxmox :
export PROXMOX_VE_API_TOKEN="terraform@pam!iac=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# ou bien par utilisateur/mot de passe :
# export PROXMOX_VE_USERNAME="root@pam"
# export PROXMOX_VE_PASSWORD="votre-mot-de-passe"
```

### Créer un token API dédié sur Proxmox

```bash
# Sur un nœud Proxmox
pveum user add terraform@pam
pveum aclmod / -user terraform@pam -role PVEAdmin
pveum user token add terraform@pam iac --privsep=0
# ⚠️  Notez le token secret affiché — il ne sera plus visible ensuite
```

## Préparer un template cloud-init

### Debian 12 (Bookworm)

```bash
# Sur un nœud Proxmox
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2

qm create 9000 --name "debian-12-cloudinit" --memory 2048 --cores 2 \
  --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-single

qm set 9000 --scsi0 local-lvm:0,import-from=$(pwd)/debian-12-genericcloud-amd64.qcow2
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot order=scsi0
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1

qm template 9000
```

### Windows Server 2022 (FS01)

Windows ne supporte pas cloud-init nativement. Méthode :

1. Installer Windows Server 2022 manuellement dans une VM
2. Installer les **VirtIO drivers** et **QEMU Guest Agent**
3. Exécuter `sysprep /generalize /shutdown /oobe`
4. Convertir la VM en template : `qm template <VMID>`
5. Cloner depuis le template dans Terraform avec `full_clone = true`

> Terraform crée le clone, mais la configuration réseau/domaine
> se fait via le playbook PowerShell `automation/powershell/fs01-bootstrap.ps1`.

## Utilisation rapide

### LAB (mono-hôte)

```bash
cd iac/terraform/lab
cp terraform.tfvars.example terraform.tfvars
# Éditer terraform.tfvars avec vos valeurs réelles

terraform init
terraform plan -out=lab.tfplan
terraform apply lab.tfplan
```

### PROD (multi-nœuds)

```bash
cd iac/terraform/prod
cp terraform.tfvars.example terraform.tfvars
# Éditer terraform.tfvars avec vos valeurs réelles

terraform init
terraform plan -out=prod.tfplan
terraform apply prod.tfplan
```

## Après le provisioning

Une fois les VMs créées par Terraform :

1. Récupérer les IPs : `terraform output -json`
2. Générer l'inventaire Ansible : `bash ../../tools/tf-to-ansible-inventory.sh`
3. Configurer les services : voir [automation/ansible/README.md](../../automation/ansible/README.md)

## Destruction

```bash
# ⚠️  ATTENTION : supprime TOUTES les VMs de l'environnement
terraform destroy
```

## Fichiers et conventions

| Fichier | Rôle |
|:--------|:-----|
| `main.tf` | Ressources principales (appels modules) |
| `variables.tf` | Déclaration des variables |
| `outputs.tf` | Sorties (IPs, noms) |
| `versions.tf` | Contraintes provider et Terraform |
| `terraform.tfvars.example` | Exemple de valeurs (sans secrets) |

## Variables à fournir

### LAB (mono-hôte)

| Variable | Description | Défaut | Obligatoire |
|:---------|:-----------|:-------|:----------:|
| `pm_api_url` | URL API Proxmox | — | ✅ |
| `pm_node` | Nom du nœud Proxmox | `pve1` | ❌ |
| `template_id_debian` | VMID du template cloud-init Debian | `9000` | ❌ |
| `storage` | Datastore Proxmox | `local-lvm` | ❌ |
| `bridge` | Bridge Proxmox principal | `vmbr0` | ❌ |
| `vlan10_prefix` | Préfixe VLAN 10 (Admin) | `192.168.10` | ❌ |
| `vlan20_prefix` | Préfixe VLAN 20 (Prod) | `192.168.20` | ❌ |
| `vlan30_prefix` | Préfixe VLAN 30 (Backup) | `192.168.30` | ❌ |
| `dns_servers` | Serveurs DNS | `[.10.10, .10.9]` | ❌ |
| `ssh_public_keys` | Clés SSH publiques | `[]` | ✅ |

### PROD (multi-nœuds)

Mêmes variables que LAB, plus :

| Variable | Description | Défaut | Obligatoire |
|:---------|:-----------|:-------|:----------:|
| `node_prod` | Nœud VMs production | `pve1` | ❌ |
| `node_infra` | Nœud VMs infrastructure | `pve2` | ❌ |
| `node_secours` | Nœud secours + NFS | `pve03` | ❌ |

> Les identifiants Proxmox (`PROXMOX_VE_API_TOKEN`)
> doivent être passés via variables d'environnement — **jamais dans `.tfvars`**.
> Voir [docs/ops/secrets.md](../../docs/ops/secrets.md).

## TODOs liés à Terraform

| TODO | Description | Statut |
|:-----|:-----------|:-------|
| TODO[003] | IP monitoring PBS (VLAN 10 vs 30) | ✅ Résolu — PBS = `192.168.30.100` (1 NIC VLAN 30) |
| TODO[004] | IPs PROD VLAN 20 | ✅ Résolu — `.105/.106/.108` (conformes pfSense) |
| TODO[005] | OS GLPI | ✅ Résolu — Debian 12 + GLPI 9.5 |

> Tous les TODOs Terraform sont résolus. Les IPs sont paramétrables
> via `terraform.tfvars` sans modifier le code.

## Liens

- [Plan IP](../../docs/architecture/ip-plan.md)
- [Guide LAB](../../docs/lab/overview.md)
- [Guide PROD](../../docs/prod/overview.md)
- [Quickstart](../../docs/quickstart.md)
