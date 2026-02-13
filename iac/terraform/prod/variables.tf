# ===========================================================================
# PROD — Variables
# Réf. : docs/architecture/ip-plan.md
# ===========================================================================

# ---- Connexion Proxmox ----

variable "pm_api_url" {
  description = "URL de l'API Proxmox (ex: https://192.168.10.11:8006/api2/json)"
  type        = string
}

# ---- Nœuds Proxmox (placement) ----

variable "node_prod" {
  description = "Nœud pour les VMs production (ex: pve1)"
  type        = string
  default     = "pve1"
}

variable "node_infra" {
  description = "Nœud pour les VMs infrastructure (ex: pve2)"
  type        = string
  default     = "pve2"
}

variable "node_secours" {
  description = "Nœud secours + NFS (ex: pve03)"
  type        = string
  default     = "pve03"
}

# ---- Templates ----

variable "template_id_debian" {
  description = "VMID du template Debian cloud-init"
  type        = number
  default     = 9000
}

# ---- Stockage ----

variable "storage" {
  description = "Datastore Proxmox pour les disques VM (ex: local-lvm, nfs-shared)"
  type        = string
  default     = "local-lvm"
}

# ---- Réseau ----

variable "bridge" {
  description = "Bridge Proxmox trunk (ex: vmbr0)"
  type        = string
  default     = "vmbr0"
}

variable "vlan10_prefix" {
  description = "Préfixe réseau VLAN 10 — Admin/Infra (ex: 192.168.10)"
  type        = string
  default     = "192.168.10"
}

variable "vlan20_prefix" {
  description = "Préfixe réseau VLAN 20 — Production (ex: 192.168.20)"
  type        = string
  default     = "192.168.20"
}

variable "vlan30_prefix" {
  description = "Préfixe réseau VLAN 30 — Backup (ex: 192.168.30)"
  type        = string
  default     = "192.168.30"
}

# ---- DNS ----

variable "dns_servers" {
  description = "Serveurs DNS (AD DC01 + DC02)"
  type        = list(string)
  default     = ["192.168.10.10", "192.168.10.9"]
}

# ---- SSH ----

variable "ssh_public_keys" {
  description = "Liste de clés SSH publiques pour cloud-init"
  type        = list(string)
  default     = []
}
