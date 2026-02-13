# ===========================================================================
# Module Cloud-Init — Génère un snippet cloud-init pour stockage Proxmox
# ===========================================================================

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.datastore_id
  node_name    = var.node_name

  source_raw {
    data      = var.content
    file_name = var.filename
  }
}
