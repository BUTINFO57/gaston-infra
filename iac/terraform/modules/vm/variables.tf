# ===========================================================================
# Module VM — Variables
# ===========================================================================

variable "name" {
  description = "Nom de la VM"
  type        = string
}

variable "target_node" {
  description = "Nœud Proxmox cible (ex: pve1)"
  type        = string
}

variable "template_id" {
  description = "VMID du template cloud-init à cloner"
  type        = number
}

variable "cores" {
  description = "Nombre de cœurs CPU"
  type        = number
  default     = 2
}

variable "sockets" {
  description = "Nombre de sockets CPU"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Mémoire RAM en Mo"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Taille du disque en Go"
  type        = number
  default     = 32
}

variable "storage" {
  description = "Datastore Proxmox (ex: local-lvm)"
  type        = string
  default     = "local-lvm"
}

variable "bridge" {
  description = "Bridge réseau Proxmox (ex: vmbr0)"
  type        = string
  default     = "vmbr0"
}

variable "vlan_tag" {
  description = "Tag VLAN (10, 20, 30 ou null)"
  type        = number
  default     = null
}

variable "ip_address" {
  description = "Adresse IP statique au format CIDR (ex: 192.168.10.10/24)"
  type        = string
}

variable "gateway" {
  description = "Passerelle par défaut (ex: 192.168.10.1)"
  type        = string
}

variable "dns_servers" {
  description = "Serveurs DNS"
  type        = list(string)
  default     = ["192.168.10.10", "192.168.10.9"]
}

variable "dns_domain" {
  description = "Domaine DNS de recherche"
  type        = string
  default     = "gaston.local"
}

variable "ci_user" {
  description = "Utilisateur cloud-init"
  type        = string
  default     = "deploy"
}

variable "ssh_keys" {
  description = "Clés SSH publiques pour cloud-init"
  type        = list(string)
  default     = []
}

variable "start_on_boot" {
  description = "Démarrer la VM au boot du nœud"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags Proxmox pour la VM"
  type        = list(string)
  default     = []
}
