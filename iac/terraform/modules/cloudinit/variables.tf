# ===========================================================================
# Module Cloud-Init — Variables
# ===========================================================================

variable "node_name" {
  description = "Nœud Proxmox cible"
  type        = string
}

variable "datastore_id" {
  description = "Datastore pour les snippets (ex: local)"
  type        = string
  default     = "local"
}

variable "filename" {
  description = "Nom du fichier snippet (ex: cloud-init-dc01.yml)"
  type        = string
}

variable "content" {
  description = "Contenu YAML du snippet cloud-init"
  type        = string
}
