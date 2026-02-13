# ⚡ Quickstart — Démarrer en 5 minutes

## 1. Cloner le repo

```bash
git clone https://github.com/BUTINFO57/gaston-infra.git
cd gaston-infra
```

## 2. Choisir votre parcours

### 🧪 J'ai 1 seul PC / serveur → Parcours LAB (recommandé)

➡️ **[Guide LAB](lab/overview.md)**

- 1 machine avec 16+ Go RAM
- Proxmox installé (ou à installer)
- VLANs virtuels via bridges
- Pas de HA réel, même architecture logique
- **Temps : ~1 h (Terraform + Ansible)**

### 🏭 J'ai 3 serveurs + switch + pfSense box → Parcours PROD

➡️ **[Guide PROD](prod/overview.md)**

- 3 serveurs physiques (HP DL360 Gen10+ ou équivalent)
- 1 PC dédié pfSense (2 NIC minimum)
- 1 switch Cisco SG350-28
- **Temps : ~10 h (1 journée)**

## 3. Préparer les secrets

```bash
cp examples/secrets.env.example .env
# Éditer .env avec vos mots de passe réels
# NE JAMAIS commiter ce fichier
```

Voir [docs/ops/secrets.md](ops/secrets.md) pour le guide complet.

## 4. Vérifier les prérequis

| Prérequis | LAB | PROD |
|:----------|:---:|:----:|
| Proxmox VE ≥ 8.0 ISO | ✅ | ✅ |
| Debian 12 cloud image | ✅ | ✅ |
| pfSense CE 24.0 ISO | ✅ (VM) | ✅ (physique) |
| Windows Server 2022 ISO | ✅ | ✅ |
| Terraform ≥ 1.6 | ✅ | ✅ |
| Ansible ≥ 2.15 | ✅ | ✅ |
| 16+ Go RAM | ✅ | ✅ (par serveur) |
| 2 NIC sur pfSense | ❌ (VM) | ✅ |
| Switch managé | ❌ (bridges) | ✅ |

## 5. Déploiement LAB en 60 minutes

### Étape 1 — Préparer le template cloud-init (15 min)

Voir [iac/terraform/README.md](../iac/terraform/README.md#préparer-un-template-cloud-init).

```bash
# Sur le nœud Proxmox : télécharger et créer le template Debian 12
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

**Validation :** `qm list` doit afficher le template 9000.

### Étape 2 — Provisionner les VMs avec Terraform (15 min)

```bash
cd iac/terraform/lab
cp terraform.tfvars.example terraform.tfvars
# Éditer terraform.tfvars : pm_api_url, pm_node, ssh_public_keys

# Exporter les identifiants Proxmox
export PM_API_TOKEN_ID="terraform@pam!iac"
export PM_API_TOKEN_SECRET="votre-token-secret"

terraform init
terraform plan -out=lab.tfplan
terraform apply lab.tfplan
```

**Validation :** `terraform output` affiche les IPs de toutes les VMs.

### Étape 3 — Générer l'inventaire Ansible (2 min)

```bash
cd ../../..
bash tools/tf-to-ansible-inventory.sh lab
```

**Validation :** `cat automation/ansible/inventories/lab.ini` contient les bonnes IPs.

### Étape 4 — Configurer les services avec Ansible (30 min)

```bash
cd automation/ansible
ansible-playbook -i inventories/lab.ini playbooks/base-linux.yml
ansible-playbook -i inventories/lab.ini playbooks/hardening-min-j0.yml
ansible-playbook -i inventories/lab.ini playbooks/mariadb.yml
ansible-playbook -i inventories/lab.ini playbooks/wordpress.yml
ansible-playbook -i inventories/lab.ini playbooks/nginx-rp.yml
ansible-playbook -i inventories/lab.ini playbooks/checkmk-agent.yml
```

**Validation :**

```bash
# Depuis votre machine locale
curl -k https://192.168.20.106  # Doit retourner la page WordPress
ssh deploy@192.168.10.10        # Doit se connecter à AD-DC01
```

### Étape 5 — Services manuels restants

| Service | Guide | Durée |
|:--------|:------|:-----:|
| pfSense (routage, FW, VPN) | [configs/pfsense/](../configs/pfsense/) | 30 min |
| Samba AD (DC01 + DC02) | [configs/samba/provision.sh.template](../configs/samba/provision.sh.template) | 20 min |
| FS01 (Windows) | [automation/powershell/](../automation/powershell/) | 15 min |
| PBS (sauvegarde) | [docs/ops/backup.md](ops/backup.md) | 15 min |
| Mailcow | [runbook §4.5](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md#45-services-socle) | 20 min |

## 6. Déploiement PROD en 1 journée

Suivre le [Runbook J0 complet](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md)
en utilisant les commandes Terraform PROD :

```bash
cd iac/terraform/prod
cp terraform.tfvars.example terraform.tfvars
# Éditer terraform.tfvars avec le placement multi-nœuds

terraform init
terraform plan -out=prod.tfplan
terraform apply prod.tfplan
bash ../../../tools/tf-to-ansible-inventory.sh prod
```

Puis configurer avec Ansible et suivre le runbook pour les services manuels.

## Liens

- [Plan IP](architecture/ip-plan.md) — Référence des adresses
- [Terraform README](../iac/terraform/README.md) — Guide IaC complet
- [Ansible README](../automation/ansible/README.md) — Playbooks et rôles
- [Gestion des secrets](ops/secrets.md) — Sécurité locale
