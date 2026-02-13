# ===========================================================================
# Module Network — Variables
# ===========================================================================

variable "node_name" {
  description = "Nœud Proxmox cible"
  type        = string
}

variable "bridges" {
  description = "Map des bridges à créer (clé = nom, value = { comment })"
  type = map(object({
    comment = string
  }))
  default = {}
}
