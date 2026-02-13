# Automatisation — Ansible & PowerShell

## Structure

```text
automation/
├── .gitkeep
├── ansible/
│   ├── README.md              ← vous êtes ici
│   ├── inventories/
│   │   ├── lab.ini.example
│   │   └── prod.ini.example
│   ├── playbooks/
│   │   ├── base-linux.yml
│   │   ├── hardening-min-j0.yml
│   │   ├── mailcow.yml
│   │   ├── checkmk-agent.yml
│   │   ├── wordpress.yml
│   │   ├── mariadb.yml
│   │   └── nginx-rp.yml
│   └── roles/
│       ├── common/   (tasks, handlers, defaults)
│       ├── ufw/      (tasks, handlers, defaults, templates)
│       ├── fail2ban/  (tasks, handlers, defaults, templates)
│       └── ssh/       (tasks, handlers, defaults)
└── powershell/
    ├── fs01-bootstrap.ps1
    └── fs01-shares.ps1
```

## Philosophie

Ce sont des **modèles de démarrage**, pas de l'automatisation de niveau production.
Ils correspondent aux procédures du runbook pour réduire le temps de déploiement le jour J0.

## Variables à configurer

Avant d'exécuter un playbook, copier l'inventaire d'exemple et définir :

| Variable | Emplacement | Exemple |
|:---------|:------|:--------|
| `ansible_host` | `inventories/*.ini` | `192.168.10.10` |
| `ansible_user` | `inventories/*.ini` | `root` |
| `domain` | `roles/common/defaults/main.yml` | `gaston.local` |
| `dns_servers` | `roles/common/defaults/main.yml` | `[192.168.10.10, 192.168.10.9]` |
| `admin_network` | `roles/ufw/defaults/main.yml` | `192.168.10.0/24` |
| `monitoring_host` | `roles/ufw/defaults/main.yml` | `192.168.10.114` |
| `ssh_port` | `roles/ssh/defaults/main.yml` | `22` |

## Utilisation — Ansible

```bash
cd automation/ansible
cp inventories/prod.ini.example inventories/prod.ini
# Modifier inventories/prod.ini avec les vraies IPs et clés SSH

# Exécuter la configuration de base sur toutes les VMs Linux
ansible-playbook -i inventories/prod.ini playbooks/base-linux.yml

# Exécuter le durcissement (jour-0 minimal)
ansible-playbook -i inventories/prod.ini playbooks/hardening-min-j0.yml

# Déployer toute la pile web
ansible-playbook -i inventories/prod.ini playbooks/mariadb.yml
ansible-playbook -i inventories/prod.ini playbooks/wordpress.yml
ansible-playbook -i inventories/prod.ini playbooks/nginx-rp.yml

# Déployer l'agent de monitoring
ansible-playbook -i inventories/prod.ini playbooks/checkmk-agent.yml
```

## Utilisation — PowerShell

```powershell
# Sur FS01 (Windows Server 2022 Core) après la configuration initiale :
.\fs01-bootstrap.ps1
# Après la jonction au domaine et le redémarrage :
.\fs01-shares.ps1
```

## Limitations

Ces playbooks n'automatisent **PAS** :

- **Proxmox VE** — mise en cluster (manuel via WebUI)
- **pfSense** — configuration (manuel via WebUI)
- **Samba AD** — provisionnement (utiliser `configs/samba/provision.sh.template`)
- **Proxmox Backup Server** (manuel via WebUI)
- **HA / Ceph / NFS** — stockage (manuel)
- **Switch SG350-28** — configuration VLAN (manuel via WebUI)

Ce sont des choix de conception délibérés — les appliances avec WebUI sont plus rapides
à configurer manuellement le jour J0 que d'automatiser pour un déploiement unique.

## Prérequis

| Outil | Version | Installation |
|:-----|:--------|:--------|
| Ansible | ≥ 2.15 | `apt install ansible` ou `pip install ansible` |
| Python | ≥ 3.10 | Pré-installé sur Debian 12 |
| sshpass | Dernière | `apt install sshpass` (pour l'auth initiale par mot de passe) |
| PowerShell | 5.1+ | Intégré à Windows Server 2022 |

## TODOs liés à Ansible

| TODO | Description | Impact |
|:-----|:-----------|:-------|
| TODO[003] | IP monitoring PBS (VLAN 10 vs 30) | Variable `monitoring_host` dans inventaire |
| TODO[006] | Auth LDAP pfSense VPN | Variable `ldap_server` dans rôles si ajouté |

> Ces TODOs ne bloquent **pas** le LAB minimal. Les valeurs par défaut
> dans `roles/*/defaults/main.yml` sont fonctionnelles.
