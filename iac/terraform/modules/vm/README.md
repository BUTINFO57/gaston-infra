# Module VM — Crée des VMs Proxmox via cloud-init

Ce module provisionne une VM Proxmox VE à partir d'un template cloud-init.

## Utilisation

```hcl
module "ad_dc01" {
  source       = "../modules/vm"
  name         = "ad-dc01"
  target_node  = "pve1"
  template_id  = 9000
  cores        = 2
  memory       = 2048
  disk_size    = 32
  bridge       = "vmbr0"
  vlan_tag     = 10
  ip_address   = "192.168.10.10/24"
  gateway      = "192.168.10.1"
  dns_servers  = ["192.168.10.10", "192.168.10.9"]
  ssh_keys     = [file("~/.ssh/id_ed25519.pub")]
}
```

## Variables

| Variable | Type | Défaut | Description |
|:---------|:-----|:-------|:------------|
| `name` | `string` | — | Nom de la VM |
| `target_node` | `string` | — | Nœud Proxmox |
| `template_id` | `number` | — | VMID du template |
| `cores` | `number` | `2` | Cœurs CPU |
| `memory` | `number` | `2048` | RAM en Mo |
| `disk_size` | `number` | `32` | Disque en Go |
| `storage` | `string` | `local-lvm` | Datastore |
| `bridge` | `string` | `vmbr0` | Bridge réseau |
| `vlan_tag` | `number` | `null` | Tag VLAN |
| `ip_address` | `string` | — | IP CIDR |
| `gateway` | `string` | — | Passerelle |
| `dns_servers` | `list(string)` | AD DCs | DNS |
| `ssh_keys` | `list(string)` | `[]` | Clés SSH |

## Outputs

| Output | Description |
|:-------|:------------|
| `vm_id` | VMID Proxmox |
| `vm_name` | Nom de la VM |
| `ipv4_address` | Adresse IPv4 |
| `node_name` | Nœud hébergeant la VM |
